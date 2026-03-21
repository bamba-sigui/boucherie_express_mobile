import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Skeleton } from '@/components/ui/skeleton'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { ShoppingCart, Clock, DollarSign, AlertTriangle } from 'lucide-react'
import { getStats } from '@/services/api'
import { toast } from 'sonner'

const fmt = (n) =>
  new Intl.NumberFormat('fr-CI', { style: 'currency', currency: 'XOF', maximumFractionDigits: 0 }).format(n ?? 0)

const STATUS_COLORS = {
  pending: 'warning',
  confirmed: 'info',
  preparing: 'secondary',
  delivering: 'default',
  delivered: 'success',
  cancelled: 'destructive',
}

const STATUS_LABELS = {
  pending: 'En attente',
  confirmed: 'Confirmée',
  preparing: 'Préparation',
  delivering: 'Livraison',
  delivered: 'Livrée',
  cancelled: 'Annulée',
}

const Dashboard = () => {
  const [stats, setStats] = useState(null)
  const [loading, setLoading] = useState(true)
  const navigate = useNavigate()

  useEffect(() => {
    getStats()
      .then(setStats)
      .catch((e) => toast.error(e.message))
      .finally(() => setLoading(false))
  }, [])

  if (loading) {
    return (
      <div className="space-y-6">
        <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-4">
          {Array.from({ length: 4 }).map((_, i) => (
            <Card key={i}>
              <CardHeader className="pb-2"><Skeleton className="h-4 w-24" /></CardHeader>
              <CardContent><Skeleton className="h-8 w-32" /></CardContent>
            </Card>
          ))}
        </div>
        <Card>
          <CardHeader><Skeleton className="h-5 w-48" /></CardHeader>
          <CardContent className="space-y-3">
            {Array.from({ length: 5 }).map((_, i) => <Skeleton key={i} className="h-12 w-full" />)}
          </CardContent>
        </Card>
      </div>
    )
  }

  if (!stats) return null

  const statCards = [
    { icon: ShoppingCart, label: 'Total commandes', value: stats.total_orders ?? 0, color: 'text-blue-400' },
    { icon: Clock, label: "Commandes du jour", value: stats.today_orders ?? 0, color: 'text-primary' },
    { icon: DollarSign, label: "Chiffre d'affaires", value: fmt(stats.total_revenue), color: 'text-green-400' },
    {
      icon: AlertTriangle,
      label: 'Ruptures de stock',
      value: stats.out_of_stock ?? 0,
      color: 'text-red-400',
      onClick: () => navigate('/stock?filter=out_of_stock'),
    },
  ]

  return (
    <div className="space-y-6">
      {/* Stat cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-4">
        {statCards.map((s, i) => {
          const Icon = s.icon
          return (
            <Card
              key={i}
              className={s.onClick ? 'cursor-pointer hover:border-primary/50 transition-colors' : ''}
              onClick={s.onClick}
            >
              <CardHeader className="flex flex-row items-center justify-between pb-2">
                <CardTitle className="text-sm font-medium text-muted-foreground">{s.label}</CardTitle>
                <Icon className={`h-4 w-4 ${s.color}`} />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold">{s.value}</div>
              </CardContent>
            </Card>
          )
        })}
      </div>

      {/* Recent orders */}
      {stats.recent_orders?.length > 0 && (
        <Card>
          <CardHeader>
            <CardTitle>Commandes récentes</CardTitle>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>ID</TableHead>
                  <TableHead>Client</TableHead>
                  <TableHead>Montant</TableHead>
                  <TableHead>Statut</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {stats.recent_orders.map((order) => (
                  <TableRow key={order.id}>
                    <TableCell className="font-mono text-xs">#{order.id?.slice(0, 8).toUpperCase()}</TableCell>
                    <TableCell className="text-sm">{order.user_email ?? 'Client'}</TableCell>
                    <TableCell className="text-primary font-medium text-sm">{fmt(order.total_amount)}</TableCell>
                    <TableCell>
                      <Badge variant={STATUS_COLORS[order.status] ?? 'secondary'}>
                        {STATUS_LABELS[order.status] ?? order.status}
                      </Badge>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      )}
    </div>
  )
}

export default Dashboard
