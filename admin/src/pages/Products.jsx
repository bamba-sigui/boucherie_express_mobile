import { useState, useEffect } from 'react'
import Header from '../components/Header'
import ProductForm from '../components/ProductForm'
import { getProducts, deleteProduct } from '../services/api'
import { useToast } from '../components/Toast'

const Products = () => {
  const toast = useToast()
  const [products, setProducts] = useState([])
  const [loading, setLoading] = useState(true)
  const [formTarget, setFormTarget] = useState(undefined) // undefined=fermé, null=nouveau, obj=édition
  const [deleteId, setDeleteId] = useState(null)

  const load = () => {
    setLoading(true)
    getProducts()
      .then((data) => setProducts(data.data ?? []))
      .catch((e) => toast(e.message, 'error'))
      .finally(() => setLoading(false))
  }

  useEffect(load, [])

  const handleDelete = async () => {
    try {
      await deleteProduct(deleteId)
      toast('Produit supprimé', 'success')
      setDeleteId(null)
      load()
    } catch (e) {
      toast(e.message, 'error')
    }
  }

  const fmt = (n) =>
    new Intl.NumberFormat('fr-CI', { style: 'currency', currency: 'XOF', maximumFractionDigits: 0 }).format(n)

  return (
    <div className="flex flex-col flex-1 overflow-hidden">
      <Header title="Produits" />

      <main className="flex-1 overflow-y-auto p-6 bg-gray-950">
        {/* Barre actions */}
        <div className="flex items-center justify-between mb-6">
          <p className="text-gray-400 text-sm">{products.length} produit(s)</p>
          <button
            onClick={() => setFormTarget(null)}
            className="bg-orange-500 hover:bg-orange-600 text-white text-sm font-medium px-4 py-2 rounded-lg transition-colors"
          >
            + Nouveau produit
          </button>
        </div>

        {/* Table */}
        <div className="bg-gray-900 border border-gray-800 rounded-xl overflow-hidden">
          {loading ? (
            <div className="flex items-center justify-center h-40">
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-orange-500" />
            </div>
          ) : products.length === 0 ? (
            <div className="text-center py-16 text-gray-500">Aucun produit</div>
          ) : (
            <table className="w-full">
              <thead>
                <tr className="border-b border-gray-800 text-left">
                  <th className="px-6 py-3 text-gray-400 text-xs font-medium uppercase">Produit</th>
                  <th className="px-6 py-3 text-gray-400 text-xs font-medium uppercase">Catégorie</th>
                  <th className="px-6 py-3 text-gray-400 text-xs font-medium uppercase">Prix</th>
                  <th className="px-6 py-3 text-gray-400 text-xs font-medium uppercase">Stock</th>
                  <th className="px-6 py-3 text-gray-400 text-xs font-medium uppercase">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-800">
                {products.map((p) => (
                  <tr key={p.id} className="hover:bg-gray-800/50 transition-colors">
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-3">
                        {p.image_url ? (
                          <img src={p.image_url} alt="" className="w-10 h-10 rounded-lg object-cover" />
                        ) : (
                          <div className="w-10 h-10 rounded-lg bg-gray-700 flex items-center justify-center text-lg">🥩</div>
                        )}
                        <div>
                          <p className="text-white text-sm font-medium">{p.name}</p>
                          <p className="text-gray-400 text-xs truncate max-w-[200px]">{p.description}</p>
                        </div>
                      </div>
                    </td>
                    <td className="px-6 py-4 text-gray-300 text-sm">{p.category}</td>
                    <td className="px-6 py-4 text-orange-400 font-medium text-sm">{fmt(p.price)}</td>
                    <td className="px-6 py-4">
                      <span className={`text-sm font-medium ${p.stock === 0 ? 'text-red-400' : p.stock < 5 ? 'text-yellow-400' : 'text-green-400'}`}>
                        {p.stock}
                      </span>
                    </td>
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-2">
                        <button
                          onClick={() => setFormTarget(p)}
                          className="text-xs px-3 py-1.5 rounded-lg bg-gray-700 hover:bg-gray-600 text-white transition-colors"
                        >
                          Modifier
                        </button>
                        <button
                          onClick={() => setDeleteId(p.id)}
                          className="text-xs px-3 py-1.5 rounded-lg bg-red-900/40 hover:bg-red-900/70 text-red-400 transition-colors"
                        >
                          Supprimer
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </main>

      {/* Modal formulaire */}
      {formTarget !== undefined && (
        <ProductForm
          product={formTarget}
          onClose={() => setFormTarget(undefined)}
          onSaved={() => { setFormTarget(undefined); load() }}
        />
      )}

      {/* Modal confirmation suppression */}
      {deleteId && (
        <div className="fixed inset-0 bg-black/70 flex items-center justify-center z-40 p-4">
          <div className="bg-gray-900 border border-gray-800 rounded-2xl p-6 w-full max-w-sm">
            <h3 className="text-white font-semibold mb-2">Supprimer le produit ?</h3>
            <p className="text-gray-400 text-sm mb-6">Cette action est irréversible.</p>
            <div className="flex gap-3">
              <button onClick={() => setDeleteId(null)} className="flex-1 py-2 rounded-lg border border-gray-700 text-gray-400 hover:text-white text-sm transition-colors">
                Annuler
              </button>
              <button onClick={handleDelete} className="flex-1 py-2 rounded-lg bg-red-600 hover:bg-red-700 text-white font-medium text-sm transition-colors">
                Supprimer
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

export default Products
