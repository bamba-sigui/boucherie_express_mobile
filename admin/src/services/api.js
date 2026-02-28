import { getIdToken } from './auth'

const BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:5000/api/v1'

/** Helper générique pour toutes les requêtes API Flask */
const request = async (path, options = {}) => {
  const token = await getIdToken()

  const res = await fetch(`${BASE_URL}${path}`, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...options.headers,
    },
  })

  const data = await res.json()
  if (!res.ok) throw new Error(data.error || `Erreur ${res.status}`)
  return data
}

// ─── Dashboard ────────────────────────────────────────────────
export const getStats = () => request('/admin/stats')

// ─── Produits ─────────────────────────────────────────────────
export const getProducts = () => request('/products')

export const createProduct = (body) =>
  request('/products', { method: 'POST', body: JSON.stringify(body) })

export const updateProduct = (id, body) =>
  request(`/products/${id}`, { method: 'PUT', body: JSON.stringify(body) })

export const deleteProduct = (id) =>
  request(`/products/${id}`, { method: 'DELETE' })

// ─── Commandes ────────────────────────────────────────────────
export const getOrders = () => request('/admin/orders')

export const updateOrderStatus = (id, status) =>
  request(`/orders/${id}/status`, { method: 'PUT', body: JSON.stringify({ status }) })

// ─── Utilisateurs ─────────────────────────────────────────────
export const getUsers = () => request('/admin/users')
