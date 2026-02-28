import { NavLink, useNavigate } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'

const navItems = [
  { path: '/',         label: 'Dashboard',     icon: '📊' },
  { path: '/products', label: 'Produits',       icon: '🥩' },
  { path: '/orders',   label: 'Commandes',      icon: '📦' },
  { path: '/users',    label: 'Utilisateurs',   icon: '👥' },
]

const Sidebar = () => {
  const { logout } = useAuth()
  const navigate = useNavigate()

  const handleLogout = async () => {
    await logout()
    navigate('/login')
  }

  return (
    <aside className="w-64 bg-gray-900 border-r border-gray-800 flex flex-col min-h-screen flex-shrink-0">
      {/* Logo */}
      <div className="p-6 border-b border-gray-800">
        <h1 className="text-orange-500 font-bold text-xl">🥩 Boucherie Express</h1>
        <p className="text-gray-500 text-xs mt-1">Panneau d'administration</p>
      </div>

      {/* Navigation */}
      <nav className="flex-1 p-4 space-y-1">
        {navItems.map((item) => (
          <NavLink
            key={item.path}
            to={item.path}
            end={item.path === '/'}
            className={({ isActive }) =>
              `flex items-center gap-3 px-4 py-3 rounded-lg text-sm transition-colors ${
                isActive
                  ? 'bg-orange-500 text-white font-medium'
                  : 'text-gray-400 hover:bg-gray-800 hover:text-white'
              }`
            }
          >
            <span className="text-base">{item.icon}</span>
            {item.label}
          </NavLink>
        ))}
      </nav>

      {/* Déconnexion */}
      <div className="p-4 border-t border-gray-800">
        <button
          onClick={handleLogout}
          className="w-full flex items-center gap-3 px-4 py-3 rounded-lg text-sm text-gray-400 hover:bg-red-900/30 hover:text-red-400 transition-colors"
        >
          <span>🚪</span>
          Déconnexion
        </button>
      </div>
    </aside>
  )
}

export default Sidebar
