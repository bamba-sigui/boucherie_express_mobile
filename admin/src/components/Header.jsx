import { useAuth } from '../context/AuthContext'

const Header = ({ title }) => {
  const { user } = useAuth()
  const initial = user?.email?.[0]?.toUpperCase() ?? 'A'

  return (
    <header className="bg-gray-900 border-b border-gray-800 px-6 py-4 flex items-center justify-between">
      <h2 className="text-white font-semibold text-lg">{title}</h2>
      <div className="flex items-center gap-3">
        <span className="text-gray-400 text-sm hidden sm:block">{user?.email}</span>
        <div className="w-8 h-8 rounded-full bg-orange-500 flex items-center justify-center text-sm font-bold text-white">
          {initial}
        </div>
      </div>
    </header>
  )
}

export default Header
