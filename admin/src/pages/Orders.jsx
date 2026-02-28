import { useState, useEffect } from 'react'
import Header from '../components/Header'
import OrderStatusSelect, { StatusBadge } from '../components/OrderStatusSelect'
import { getOrders, updateOrderStatus } from '../services/api'
import { useToast } from '../components/Toast'

const Orders = () => {
  const toast = useToast()
  const [orders, setOrders] = useState([])
  const [loading, setLoading] = useState(true)
  const [updating, setUpdating] = useState(null) // id en cours de mise à jour

  useEffect(() => {
    getOrders()
      .then((data) => setOrders(data.orders ?? data))
      .catch((e) => toast(e.message, 'error'))
      .finally(() => setLoading(false))
  }, [])

  const handleStatusChange = async (id, status) => {
    setUpdating(id)
    try {
      await updateOrderStatus(id, status)
      setOrders((prev) => prev.map((o) => (o.id === id ? { ...o, status } : o)))
      toast('Statut mis à jour ✓', 'success')
    } catch (e) {
      toast(e.message, 'error')
    } finally {
      setUpdating(null)
    }
  }

  const fmt = (n) =>
    new Intl.NumberFormat('fr-CI', { style: 'currency', currency: 'XOF', maximumFractionDigits: 0 }).format(n)

  const fmtDate = (ts) => {
    if (!ts) return '—'
    const d = ts._seconds ? new Date(ts._seconds * 1000) : new Date(ts)
    return d.toLocaleDateString('fr-FR', { day: '2-digit', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' })
  }

  return (
    <div className="flex flex-col flex-1 overflow-hidden">
      <Header title="Commandes" />

      <main className="flex-1 overflow-y-auto p-6 bg-gray-950">
        <p className="text-gray-400 text-sm mb-6">{orders.length} commande(s)</p>

        <div className="bg-gray-900 border border-gray-800 rounded-xl overflow-x-auto">
          {loading ? (
            <div className="flex items-center justify-center h-40">
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-orange-500" />
            </div>
          ) : orders.length === 0 ? (
            <div className="text-center py-16 text-gray-500">Aucune commande</div>
          ) : (
            <table className="w-full min-w-[700px]">
              <thead>
                <tr className="border-b border-gray-800 text-left">
                  <th className="px-6 py-3 text-gray-400 text-xs font-medium uppercase">ID</th>
                  <th className="px-6 py-3 text-gray-400 text-xs font-medium uppercase">Client</th>
                  <th className="px-6 py-3 text-gray-400 text-xs font-medium uppercase">Montant</th>
                  <th className="px-6 py-3 text-gray-400 text-xs font-medium uppercase">Date</th>
                  <th className="px-6 py-3 text-gray-400 text-xs font-medium uppercase">Statut</th>
                  <th className="px-6 py-3 text-gray-400 text-xs font-medium uppercase">Action</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-800">
                {orders.map((order) => (
                  <tr key={order.id} className="hover:bg-gray-800/50 transition-colors">
                    <td className="px-6 py-4 text-gray-300 font-mono text-xs">
                      #{order.id?.slice(0, 8).toUpperCase()}
                    </td>
                    <td className="px-6 py-4">
                      <p className="text-white text-sm">{order.user_email ?? '—'}</p>
                      <p className="text-gray-400 text-xs">{order.user_phone ?? ''}</p>
                    </td>
                    <td className="px-6 py-4 text-orange-400 font-medium text-sm">
                      {fmt(order.total_amount)}
                    </td>
                    <td className="px-6 py-4 text-gray-400 text-xs">
                      {fmtDate(order.ordered_at ?? order.created_at)}
                    </td>
                    <td className="px-6 py-4">
                      <StatusBadge status={order.status} />
                    </td>
                    <td className="px-6 py-4">
                      <OrderStatusSelect
                        value={order.status}
                        onChange={(s) => handleStatusChange(order.id, s)}
                        disabled={updating === order.id}
                      />
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </main>
    </div>
  )
}

export default Orders
