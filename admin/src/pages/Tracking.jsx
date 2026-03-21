import { useState, useEffect, useMemo } from 'react'
import { useSearchParams } from 'react-router-dom'
import DataTable from '@/components/DataTable'
import TrackingDetail from '@/components/TrackingDetail'
import { StatusBadge } from '@/components/OrderStatusSelect'
import { Button } from '@/components/ui/button'
import { Eye } from 'lucide-react'
import { getOrders } from '@/services/api'
import { toast } from 'sonner'

const fmt = (n) =>
  new Intl.NumberFormat('fr-CI', { style: 'currency', currency: 'XOF', maximumFractionDigits: 0 }).format(n)

const ACTIVE_STATUSES = ['pending', 'confirmed', 'preparing', 'delivering']

const Tracking = () => {
  const [orders, setOrders] = useState([])
  const [loading, setLoading] = useState(true)
  const [selectedOrder, setSelectedOrder] = useState(null)
  const [sheetOpen, setSheetOpen] = useState(false)
  const [searchParams] = useSearchParams()

  useEffect(() => {
    getOrders()
      .then((data) => {
        const all = data.data ?? []
        setOrders(all)
        const orderId = searchParams.get('order')
        if (orderId) {
          const found = all.find((o) => o.id === orderId)
          if (found) {
            setSelectedOrder(found)
            setSheetOpen(true)
          }
        }
      })
      .catch((e) => toast.error(e.message))
      .finally(() => setLoading(false))
  }, [])

  const activeOrders = orders.filter((o) => ACTIVE_STATUSES.includes(o.status))

  const handleUpdated = (orderId, newStatus) => {
    setOrders((prev) => prev.map((o) => (o.id === orderId ? { ...o, status: newStatus } : o)))
    setSelectedOrder((prev) => prev && prev.id === orderId ? { ...prev, status: newStatus } : prev)
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
      cell: ({ getValue }) => <span className="text-sm">{getValue() ?? '—'}</span>,
    },
    {
      accessorKey: 'total_amount',
      header: 'Montant',
      cell: ({ getValue }) => <span className="text-primary font-medium text-sm">{fmt(getValue())}</span>,
    },
    {
      accessorKey: 'status',
      header: 'Statut',
      cell: ({ getValue }) => <StatusBadge status={getValue()} />,
    },
    {
      id: 'actions',
      header: '',
      cell: ({ row }) => (
        <Button
          variant="outline"
          size="sm"
          onClick={() => { setSelectedOrder(row.original); setSheetOpen(true) }}
        >
          <Eye className="mr-1 h-4 w-4" />Voir suivi
        </Button>
      ),
    },
  ], [])

  return (
    <div className="space-y-4">
      <p className="text-sm text-muted-foreground">{activeOrders.length} livraison(s) active(s)</p>

      <DataTable
        columns={columns}
        data={activeOrders}
        loading={loading}
        searchColumn="user_email"
        searchPlaceholder="Rechercher par email..."
        emptyMessage="Aucune livraison active"
      />

      <TrackingDetail
        order={selectedOrder}
        open={sheetOpen}
        onOpenChange={setSheetOpen}
        onUpdated={handleUpdated}
      />
    </div>
  )
}

export default Tracking
