import { useState, useEffect } from 'react'
import Header from '../components/Header'
import { getStats } from '../services/api'

const StatCard = ({ icon, label, value, sub, color }) => (
  <div className="bg-gray-900 border border-gray-800 rounded-xl p-6">
    <div className="flex items-center justify-between mb-4">
      <span className="text-2xl">{icon}</span>
      <span className={`text-xs font-medium px-2 py-1 rounded-full ${color}`}>{sub}</span>
    </div>
    <p className="text-2xl font-bold text-white">{value}</p>
    <p className="text-gray-400 text-sm mt-1">{label}</p>
  </div>
)

const Dashboard = () => {
  const [stats, setStats] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    getStats()
      .then(setStats)
      .catch((e) => setError(e.message))
      .finally(() => setLoading(false))
  }, [])

  const fmt = (n) =>
    new Intl.NumberFormat('fr-CI', { style: 'currency', currency: 'XOF', maximumFractionDigits: 0 }).format(n ?? 0)

  return (
    <div className="flex flex-col flex-1 overflow-hidden">
      <Header title="Dashboard" />

      <main className="flex-1 overflow-y-auto p-6 bg-gray-950">
        {loading && (
          <div className="flex items-center justify-center h-64">
            <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-orange-500" />
          </div>
        )}

        {error && (
          <div className="bg-red-900/30 border border-red-800 rounded-xl p-4 text-red-400 text-sm">
            ⚠ {error}
          </div>
        )}

        {stats && (
          <>
            {/* Cartes stats */}
            <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-4 mb-8">
              <StatCard
                icon="📦"
                label="Total commandes"
                value={stats.total_orders ?? '—'}
                sub="Toutes"
                color="bg-blue-400/10 text-blue-400"
              />
              <StatCard
                icon="🕐"
                label="Commandes du jour"
                value={stats.today_orders ?? '—'}
                sub="Aujourd'hui"
                color="bg-orange-400/10 text-orange-400"
              />
              <StatCard
                icon="💰"
                label="Chiffre d'affaires"
                value={fmt(stats.total_revenue)}
                sub="Total"
                color="bg-green-400/10 text-green-400"
              />
              <StatCard
                icon="⚠️"
                label="Rupture de stock"
                value={stats.out_of_stock ?? '—'}
                sub="Produits"
                color="bg-red-400/10 text-red-400"
              />
            </div>

            {/* Résumé commandes récentes */}
            {stats.recent_orders?.length > 0 && (
              <div className="bg-gray-900 border border-gray-800 rounded-xl">
                <div className="px-6 py-4 border-b border-gray-800">
                  <h3 className="text-white font-medium">Commandes récentes</h3>
                </div>
                <div className="divide-y divide-gray-800">
                  {stats.recent_orders.map((order) => (
                    <div key={order.id} className="px-6 py-4 flex items-center justify-between">
                      <div>
                        <p className="text-white text-sm font-medium">#{order.id?.slice(0, 8).toUpperCase()}</p>
                        <p className="text-gray-400 text-xs mt-0.5">{order.user_email ?? 'Client'}</p>
                      </div>
                      <div className="text-right">
                        <p className="text-orange-400 font-medium text-sm">{fmt(order.total_amount)}</p>
                        <p className="text-gray-400 text-xs mt-0.5">{order.status}</p>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </>
        )}
      </main>
    </div>
  )
}

export default Dashboard
