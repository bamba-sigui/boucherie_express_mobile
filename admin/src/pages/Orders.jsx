import { useState, useEffect, useMemo } from 'react'
import { useNavigate } from 'react-router-dom'
import DataTable from '@/components/DataTable'
import OrderStatusSelect, { StatusBadge, STATUS_OPTIONS } from '@/components/OrderStatusSelect'
import { Tabs, TabsList, TabsTrigger, TabsContent } from '@/components/ui/tabs'
import { Button } from '@/components/ui/button'
import { Eye } from 'lucide-react'
import { getOrders, updateOrderStatus } from '@/services/api'
import { toast } from 'sonner'

const fmt = (n) =>
  new Intl.NumberFormat('fr-CI', { style: 'currency', currency: 'XOF', maximumFractionDigits: 0 }).format(n)

const fmtDate = (ts) => {
  if (!ts) return '—'
  const d = ts._seconds ? new Date(ts._seconds * 1000) : new Date(ts)
  return d.toLocaleDateString('fr-FR', { day: '2-digit', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' })
}

const Orders = () => {
  const [orders, setOrders] = useState([])
  const [loading, setLoading] = useState(true)
  const [updating, setUpdating] = useState(null)
  const navigate = useNavigate()

  useEffect(() => {
    getOrders()
      .then((data) => setOrders(data.data ?? []))
      .catch((e) => toast.error(e.message))
      .finally(() => setLoading(false))
  }, [])

  const handleStatusChange = async (id, status) => {
    setUpdating(id)
    try {
      await updateOrderStatus(id, status)
      setOrders((prev) => prev.map((o) => (o.id === id ? { ...o, status } : o)))
      toast.success('Statut mis à jour')
    } catch (e) {
      toast.error(e.message)
    } finally {
      setUpdating(null)
    }
  }

  const columns = useMemo(() => [
    {
      accessorKey: 'id',
      header: 'ID',
      cell: ({ getValue }) => <span className="font-mono text-xs">#{getValue()?.slice(0, 8).toUpperCase()}</span>,
    },
    {
      accessorKey: 'user_email',
      header: 'Client',
      cell: ({ row }) => (
        <div>
          <p className="text-sm">{row.original.user_email ?? '—'}</p>
          <p className="text-xs text-muted-foreground">{row.original.user_phone ?? ''}</p>
        </div>
      ),
    },
    {
      accessorKey: 'total_amount',
      header: 'Montant',
      cell: ({ getValue }) => <span className="text-primary font-medium text-sm">{fmt(getValue())}</span>,
    },
    {
      id: 'date',
      header: 'Date',
      accessorFn: (row) => row.ordered_at ?? row.created_at,
      cell: ({ getValue }) => <span className="text-xs text-muted-foreground">{fmtDate(getValue())}</span>,
    },
    {
      accessorKey: 'status',
      header: 'Statut',
      cell: ({ row }) => (
        <OrderStatusSelect
          value={row.original.status}
          onChange={(s) => handleStatusChange(row.original.id, s)}
          disabled={updating === row.original.id}
        />
      ),
    },
    {
      id: 'actions',
      header: '',
      cell: ({ row }) => (
        <Button variant="ghost" size="sm" onClick={() => navigate(`/tracking?order=${row.original.id}`)}>
          <Eye className="mr-1 h-4 w-4" />Suivi
        </Button>
      ),
    },
  ], [updating])

  const tabs = [
    { value: 'all', label: 'Toutes', filter: () => true },
    ...STATUS_OPTIONS.map((s) => ({ value: s.value, label: s.label, filter: (o) => o.status === s.value })),
  ]

  return (
    <Tabs defaultValue="all">
      <TabsList className="flex-wrap h-auto gap-1">
        {tabs.map((t) => (
          <TabsTrigger key={t.value} value={t.value}>
            {t.label} ({orders.filter(t.filter).length})
          </TabsTrigger>
        ))}
      </TabsList>

      {tabs.map((t) => (
        <TabsContent key={t.value} value={t.value}>
          <DataTable
            columns={columns}
            data={orders.filter(t.filter)}
            loading={loading}
            searchColumn="user_email"
            searchPlaceholder="Rechercher par email..."
            emptyMessage="Aucune commande"
          />
        </TabsContent>
      ))}
    </Tabs>
  )
}

export default Orders
