import { useState, useEffect } from 'react'
import { ref, uploadBytesResumable, getDownloadURL } from 'firebase/storage'
import { storage } from '../services/firebase'
import { createProduct, updateProduct } from '../services/api'
import { useToast } from './Toast'

/**
 * Modal formulaire — Créer ou modifier un produit.
 * Props:
 *   product  : produit à modifier (null = création)
 *   onClose  : ferme le modal
 *   onSaved  : callback après sauvegarde réussie
 */
const ProductForm = ({ product, onClose, onSaved }) => {
  const toast = useToast()
  const isEdit = !!product

  const [form, setForm] = useState({
    name: product?.name ?? '',
    description: product?.description ?? '',
    price: product?.price ?? '',
    category: product?.category ?? '',
    stock: product?.stock ?? '',
  })
  const [imageFile, setImageFile] = useState(null)
  const [imagePreview, setImagePreview] = useState(product?.image_url ?? null)
  const [uploadProgress, setUploadProgress] = useState(0)
  const [loading, setLoading] = useState(false)

  const handleChange = (e) => {
    setForm((prev) => ({ ...prev, [e.target.name]: e.target.value }))
  }

  const handleImage = (e) => {
    const file = e.target.files[0]
    if (!file) return
    setImageFile(file)
    setImagePreview(URL.createObjectURL(file))
  }

  const uploadImage = () =>
    new Promise((resolve, reject) => {
      const storageRef = ref(storage, `products/${Date.now()}_${imageFile.name}`)
      const task = uploadBytesResumable(storageRef, imageFile)
      task.on(
        'state_changed',
        (snap) => setUploadProgress(Math.round((snap.bytesTransferred / snap.totalBytes) * 100)),
        reject,
        async () => resolve(await getDownloadURL(task.snapshot.ref)),
      )
    })

  const handleSubmit = async (e) => {
    e.preventDefault()
    setLoading(true)
    try {
      let imageUrl = product?.image_url ?? null
      if (imageFile) imageUrl = await uploadImage()

      const body = {
        name: form.name,
        description: form.description,
        price: parseFloat(form.price),
        category: form.category,
        stock: parseInt(form.stock),
        ...(imageUrl ? { image_url: imageUrl } : {}),
      }

      isEdit ? await updateProduct(product.id, body) : await createProduct(body)
      toast(isEdit ? 'Produit modifié ✓' : 'Produit créé ✓', 'success')
      onSaved()
    } catch (err) {
      toast(err.message, 'error')
    } finally {
      setLoading(false)
    }
  }

  return (
    /* Overlay */
    <div className="fixed inset-0 bg-black/70 flex items-center justify-center z-40 p-4">
      <div className="bg-gray-900 border border-gray-800 rounded-2xl w-full max-w-lg max-h-[90vh] overflow-y-auto">
        {/* En-tête */}
        <div className="flex items-center justify-between p-6 border-b border-gray-800">
          <h3 className="text-white font-semibold text-lg">
            {isEdit ? 'Modifier le produit' : 'Nouveau produit'}
          </h3>
          <button onClick={onClose} className="text-gray-400 hover:text-white transition-colors">✕</button>
        </div>

        <form onSubmit={handleSubmit} className="p-6 space-y-4">
          {/* Image */}
          <div>
            <label className="block text-gray-400 text-sm mb-2">Image du produit</label>
            <div className="flex items-center gap-4">
              {imagePreview && (
                <img src={imagePreview} alt="" className="w-16 h-16 rounded-lg object-cover border border-gray-700" />
              )}
              <label className="cursor-pointer bg-gray-800 hover:bg-gray-700 border border-gray-700 border-dashed rounded-lg px-4 py-2 text-sm text-gray-400 hover:text-white transition-colors">
                📷 Choisir une image
                <input type="file" accept="image/*" className="hidden" onChange={handleImage} />
              </label>
            </div>
            {uploadProgress > 0 && uploadProgress < 100 && (
              <div className="mt-2 h-1.5 bg-gray-700 rounded-full overflow-hidden">
                <div className="h-full bg-orange-500 transition-all" style={{ width: `${uploadProgress}%` }} />
              </div>
            )}
          </div>

          {/* Nom */}
          <div>
            <label className="block text-gray-400 text-sm mb-1">Nom *</label>
            <input
              name="name" value={form.name} onChange={handleChange} required
              className="w-full bg-gray-800 border border-gray-700 rounded-lg px-3 py-2 text-white text-sm focus:border-orange-500 outline-none"
              placeholder="Ex: Côtelettes d'agneau"
            />
          </div>

          {/* Description */}
          <div>
            <label className="block text-gray-400 text-sm mb-1">Description</label>
            <textarea
              name="description" value={form.description} onChange={handleChange} rows={3}
              className="w-full bg-gray-800 border border-gray-700 rounded-lg px-3 py-2 text-white text-sm focus:border-orange-500 outline-none resize-none"
              placeholder="Description du produit..."
            />
          </div>

          {/* Prix + Stock */}
          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="block text-gray-400 text-sm mb-1">Prix (FCFA) *</label>
              <input
                type="number" name="price" value={form.price} onChange={handleChange} required min="0" step="50"
                className="w-full bg-gray-800 border border-gray-700 rounded-lg px-3 py-2 text-white text-sm focus:border-orange-500 outline-none"
                placeholder="5000"
              />
            </div>
            <div>
              <label className="block text-gray-400 text-sm mb-1">Stock *</label>
              <input
                type="number" name="stock" value={form.stock} onChange={handleChange} required min="0"
                className="w-full bg-gray-800 border border-gray-700 rounded-lg px-3 py-2 text-white text-sm focus:border-orange-500 outline-none"
                placeholder="10"
              />
            </div>
          </div>

          {/* Catégorie */}
          <div>
            <label className="block text-gray-400 text-sm mb-1">Catégorie *</label>
            <input
              name="category" value={form.category} onChange={handleChange} required
              className="w-full bg-gray-800 border border-gray-700 rounded-lg px-3 py-2 text-white text-sm focus:border-orange-500 outline-none"
              placeholder="Ex: Bœuf, Agneau, Poulet..."
            />
          </div>

          {/* Actions */}
          <div className="flex gap-3 pt-2">
            <button
              type="button" onClick={onClose}
              className="flex-1 py-2.5 rounded-lg border border-gray-700 text-gray-400 hover:text-white hover:border-gray-500 text-sm transition-colors"
            >
              Annuler
            </button>
            <button
              type="submit" disabled={loading}
              className="flex-1 py-2.5 rounded-lg bg-orange-500 hover:bg-orange-600 text-white font-medium text-sm transition-colors disabled:opacity-50"
            >
              {loading ? 'Enregistrement...' : isEdit ? 'Modifier' : 'Créer'}
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}

export default ProductForm
