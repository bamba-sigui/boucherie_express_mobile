import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { AuthProvider } from './context/AuthContext'
import { ToastProvider } from './components/Toast'
import ProtectedRoute from './components/ProtectedRoute'
import Sidebar from './components/Sidebar'
import Login from './pages/Login'
import Dashboard from './pages/Dashboard'
import Products from './pages/Products'
import Orders from './pages/Orders'
import Users from './pages/Users'

/** Layout principal (sidebar + contenu) pour les pages protégées */
const AdminLayout = ({ children }) => (
  <div className="flex h-screen bg-gray-950 overflow-hidden">
    <Sidebar />
    <div className="flex flex-col flex-1 overflow-hidden">
      {children}
    </div>
  </div>
)

const App = () => (
  <BrowserRouter>
    <AuthProvider>
      <ToastProvider>
        <Routes>
          {/* Page publique */}
          <Route path="/login" element={<Login />} />

          {/* Pages protégées — admin uniquement */}
          <Route
            path="/"
            element={
              <ProtectedRoute>
                <AdminLayout><Dashboard /></AdminLayout>
              </ProtectedRoute>
            }
          />
          <Route
            path="/products"
            element={
              <ProtectedRoute>
                <AdminLayout><Products /></AdminLayout>
              </ProtectedRoute>
            }
          />
          <Route
            path="/orders"
            element={
              <ProtectedRoute>
                <AdminLayout><Orders /></AdminLayout>
              </ProtectedRoute>
            }
          />
          <Route
            path="/users"
            element={
              <ProtectedRoute>
                <AdminLayout><Users /></AdminLayout>
              </ProtectedRoute>
            }
          />

          {/* Fallback */}
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </ToastProvider>
    </AuthProvider>
  </BrowserRouter>
)

export default App
