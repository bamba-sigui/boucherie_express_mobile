import { Navigate } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'

/**
 * Protège toutes les routes admin.
 * - Non connecté → /login
 * - Connecté non-admin → géré par AuthContext (déconnexion auto)
 */
const ProtectedRoute = ({ children }) => {
  const { user, loading } = useAuth()

  if (loading) {
    return (
      <div className="flex items-center justify-center h-screen bg-gray-950">
        <div className="flex flex-col items-center gap-4">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-orange-500" />
          <span className="text-gray-400 text-sm">Vérification...</span>
        </div>
      </div>
    )
  }

  if (!user) return <Navigate to="/login" replace />

  return children
}

export default ProtectedRoute
