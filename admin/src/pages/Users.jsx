import { useState, useEffect } from 'react'
import Header from '../components/Header'
import { getUsers } from '../services/api'
import { useToast } from '../components/Toast'

const Users = () => {
  const toast = useToast()
  const [users, setUsers] = useState([])
  const [loading, setLoading] = useState(true)
  const [search, setSearch] = useState('')

  useEffect(() => {
    getUsers()
      .then((data) => setUsers(data.users ?? data))
      .catch((e) => toast(e.message, 'error'))
      .finally(() => setLoading(false))
  }, [])

  const filtered = users.filter(
    (u) =>
      u.email?.toLowerCase().includes(search.toLowerCase()) ||
      u.phone?.includes(search),
  )

  return (
    <div className="flex flex-col flex-1 overflow-hidden">
      <Header title="Utilisateurs" />

      <main className="flex-1 overflow-y-auto p-6 bg-gray-950">
        {/* Barre de recherche */}
        <div className="flex items-center gap-4 mb-6">
          <input
            type="text"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Rechercher par email ou téléphone..."
            className="bg-gray-900 border border-gray-700 rounded-lg px-4 py-2 text-white text-sm
                       focus:border-orange-500 outline-none w-full max-w-sm placeholder-gray-500"
          />
          <span className="text-gray-400 text-sm">{filtered.length} utilisateur(s)</span>
        </div>

        {/* Table */}
        <div className="bg-gray-900 border border-gray-800 rounded-xl overflow-x-auto">
          {loading ? (
            <div className="flex items-center justify-center h-40">
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-orange-500" />
            </div>
          ) : filtered.length === 0 ? (
            <div className="text-center py-16 text-gray-500">Aucun utilisateur</div>
          ) : (
            <table className="w-full min-w-[500px]">
              <thead>
                <tr className="border-b border-gray-800 text-left">
                  <th className="px-6 py-3 text-gray-400 text-xs font-medium uppercase">Utilisateur</th>
                  <th className="px-6 py-3 text-gray-400 text-xs font-medium uppercase">Téléphone</th>
                  <th className="px-6 py-3 text-gray-400 text-xs font-medium uppercase">Commandes</th>
                  <th className="px-6 py-3 text-gray-400 text-xs font-medium uppercase">Rôle</th>
                  <th className="px-6 py-3 text-gray-400 text-xs font-medium uppercase">Inscription</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-800">
                {filtered.map((u) => (
                  <tr key={u.uid} className="hover:bg-gray-800/50 transition-colors">
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-3">
                        <div className="w-8 h-8 rounded-full bg-orange-500/20 text-orange-400 flex items-center justify-center text-sm font-bold">
                          {u.email?.[0]?.toUpperCase() ?? '?'}
                        </div>
                        <span className="text-white text-sm">{u.email ?? '—'}</span>
                      </div>
                    </td>
                    <td className="px-6 py-4 text-gray-300 text-sm">{u.phone ?? '—'}</td>
                    <td className="px-6 py-4">
                      <span className="text-orange-400 font-medium text-sm">{u.orders_count ?? 0}</span>
                    </td>
                    <td className="px-6 py-4">
                      <span className={`text-xs px-2 py-1 rounded-full font-medium ${
                        u.role === 'admin'
                          ? 'bg-orange-400/10 text-orange-400'
                          : 'bg-gray-700 text-gray-400'
                      }`}>
                        {u.role ?? 'user'}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-gray-400 text-xs">
                      {u.created_at
                        ? new Date(u.created_at._seconds * 1000).toLocaleDateString('fr-FR')
                        : '—'}
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

export default Users
