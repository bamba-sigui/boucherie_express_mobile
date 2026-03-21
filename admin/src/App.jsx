import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { AuthProvider } from './context/AuthContext'
import ProtectedRoute from './components/ProtectedRoute'
import AdminLayout from './components/layout/AdminLayout'
import Login from './pages/Login'
import Dashboard from './pages/Dashboard'
import Products from './pages/Products'
import Categories from './pages/Categories'
import Stock from './pages/Stock'
import Orders from './pages/Orders'
import Tracking from './pages/Tracking'
import Users from './pages/Users'

const pages = [
  { path: '/', element: <Dashboard />, title: 'Dashboard' },
  { path: '/products', element: <Products />, title: 'Produits' },
  { path: '/categories', element: <Categories />, title: 'Catégories' },
  { path: '/stock', element: <Stock />, title: 'Stock' },
  { path: '/orders', element: <Orders />, title: 'Commandes' },
  { path: '/tracking', element: <Tracking />, title: 'Livraisons' },
  { path: '/users', element: <Users />, title: 'Clients' },
]

const App = () => (
  <BrowserRouter>
    <AuthProvider>
      <Routes>
        <Route path="/login" element={<Login />} />

        {pages.map(({ path, element, title }) => (
          <Route
            key={path}
            path={path}
            element={
              <ProtectedRoute>
                <AdminLayout title={title}>{element}</AdminLayout>
              </ProtectedRoute>
            }
          />
        ))}

        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </AuthProvider>
  </BrowserRouter>
)

export default App
