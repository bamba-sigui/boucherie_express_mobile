import { useState, useEffect } from 'react'
import { ref, uploadBytesResumable, getDownloadURL } from 'firebase/storage'
import { storage } from '@/services/firebase'
import { createProduct, updateProduct, getCategories } from '@/services/api'
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from '@/components/ui/dialog'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Textarea } from '@/components/ui/textarea'
import { Button } from '@/components/ui/button'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { Checkbox } from '@/components/ui/checkbox'
import { Badge } from '@/components/ui/badge'
import { Loader2, ImagePlus, X } from 'lucide-react'
import { toast } from 'sonner'

const UNITS = ['kg', 'pièce', 'lot', 'barquette']

const ProductForm = ({ product, open, onOpenChange, onSaved }) => {
  const isEdit = !!product

  const [form, setForm] = useState({
    name: product?.name ?? '',
    description: product?.description ?? '',
    price: product?.price ?? '',
    stock: product?.stock ?? '',
    category_id: product?.category_id ?? '',
    farmName: product?.farmName ?? '',
    unit: product?.unit ?? 'kg',
    isBio: product?.isBio ?? false,
    isFresh: product?.isFresh ?? false,
    is_active: product?.is_active ?? true,
  })
  const [preparationOptions, setPreparationOptions] = useState(product?.preparationOptions ?? [])
  const [prepInput, setPrepInput] = useState('')
  const [categories, setCategories] = useState([])
  const [imageFile, setImageFile] = useState(null)
  const [imagePreview, setImagePreview] = useState(
    product?.images?.[0] ?? product?.image_url ?? null,
  )
  const [uploadProgress, setUploadProgress] = useState(0)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    getCategories()
      .then((res) => setCategories(res.data ?? []))
      .catch(() => {})
  }, [])

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

  const handlePrepKeyDown = (e) => {
    if (e.key === 'Enter' || e.key === ',') {
      e.preventDefault()
      const val = prepInput.trim().replace(/,$/, '')
      if (val && !preparationOptions.includes(val)) {
        setPreparationOptions((prev) => [...prev, val])
      }
      setPrepInput('')
    }
  }

  const removePrepOption = (opt) => {
    setPreparationOptions((prev) => prev.filter((o) => o !== opt))
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setLoading(true)
    try {
      let imageUrl = product?.images?.[0] ?? product?.image_url ?? null
      if (imageFile) imageUrl = await uploadImage()

      const body = {
        name: form.name,
        description: form.description,
        price: parseFloat(form.price),
        category_id: form.category_id,
        stock: parseInt(form.stock),
        images: imageUrl ? [imageUrl] : (product?.images ?? []),
        preparationOptions,
        farmName: form.farmName,
        unit: form.unit,
        isBio: form.isBio,
        isFresh: form.isFresh,
        is_active: form.is_active,
      }

      isEdit ? await updateProduct(product.id, body) : await createProduct(body)
      toast.success(isEdit ? 'Produit modifié' : 'Produit créé')
      onSaved()
    } catch (err) {
      toast.error(err.message)
    } finally {
      setLoading(false)
    }
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-lg max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>{isEdit ? 'Modifier le produit' : 'Nouveau produit'}</DialogTitle>
        </DialogHeader>

        <form onSubmit={handleSubmit} className="space-y-4">
          {/* Image */}
          <div className="space-y-2">
            <Label>Image du produit</Label>
            <div className="flex items-center gap-4">
              {imagePreview && (
                <img src={imagePreview} alt="" className="w-16 h-16 rounded-lg object-cover border" />
              )}
              <label className="cursor-pointer">
                <Button type="button" variant="outline" size="sm" asChild>
                  <span><ImagePlus className="mr-2 h-4 w-4" />Choisir une image</span>
                </Button>
                <input type="file" accept="image/*" className="hidden" onChange={handleImage} />
              </label>
            </div>
            {uploadProgress > 0 && uploadProgress < 100 && (
              <div className="h-1.5 bg-muted rounded-full overflow-hidden">
                <div className="h-full bg-primary transition-all" style={{ width: `${uploadProgress}%` }} />
              </div>
            )}
          </div>

          <div className="space-y-2">
            <Label htmlFor="name">Nom *</Label>
            <Input id="name" name="name" value={form.name} onChange={handleChange} required placeholder="Ex: Côtelettes d'agneau" />
          </div>

          <div className="space-y-2">
            <Label htmlFor="description">Description</Label>
            <Textarea id="description" name="description" value={form.description} onChange={handleChange} rows={3} placeholder="Description du produit..." />
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label htmlFor="price">Prix (FCFA) *</Label>
              <Input id="price" type="number" name="price" value={form.price} onChange={handleChange} required min="0" step="50" placeholder="5000" />
            </div>
            <div className="space-y-2">
              <Label htmlFor="stock">Stock *</Label>
              <Input id="stock" type="number" name="stock" value={form.stock} onChange={handleChange} required min="0" placeholder="10" />
            </div>
          </div>

          {/* Catégorie - Select dynamique */}
          <div className="space-y-2">
            <Label>Catégorie *</Label>
            <Select value={form.category_id} onValueChange={(val) => setForm((prev) => ({ ...prev, category_id: val }))}>
              <SelectTrigger>
                <SelectValue placeholder="Sélectionner une catégorie" />
              </SelectTrigger>
              <SelectContent>
                {categories.map((cat) => (
                  <SelectItem key={cat.id} value={cat.id}>{cat.name}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          {/* Unité */}
          <div className="space-y-2">
            <Label>Unité</Label>
            <Select value={form.unit} onValueChange={(val) => setForm((prev) => ({ ...prev, unit: val }))}>
              <SelectTrigger>
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                {UNITS.map((u) => (
                  <SelectItem key={u} value={u}>{u}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          {/* Ferme */}
          <div className="space-y-2">
            <Label htmlFor="farmName">Nom de la ferme</Label>
            <Input id="farmName" name="farmName" value={form.farmName} onChange={handleChange} placeholder="Ex: Ferme de la vallée" />
          </div>

          {/* Options de préparation */}
          <div className="space-y-2">
            <Label>Options de préparation</Label>
            <Input
              value={prepInput}
              onChange={(e) => setPrepInput(e.target.value)}
              onKeyDown={handlePrepKeyDown}
              placeholder="Taper une option puis Entrée (ex: Entier, Découpé)"
            />
            {preparationOptions.length > 0 && (
              <div className="flex flex-wrap gap-1.5 mt-1.5">
                {preparationOptions.map((opt) => (
                  <Badge key={opt} variant="secondary" className="cursor-pointer gap-1" onClick={() => removePrepOption(opt)}>
                    {opt}
                    <X className="h-3 w-3" />
                  </Badge>
                ))}
              </div>
            )}
          </div>

          {/* Checkboxes */}
          <div className="space-y-3">
            <div className="flex items-center gap-2">
              <Checkbox
                id="isBio"
                checked={form.isBio}
                onCheckedChange={(checked) => setForm((prev) => ({ ...prev, isBio: !!checked }))}
              />
              <Label htmlFor="isBio" className="cursor-pointer">Produit Bio</Label>
            </div>
            <div className="flex items-center gap-2">
              <Checkbox
                id="isFresh"
                checked={form.isFresh}
                onCheckedChange={(checked) => setForm((prev) => ({ ...prev, isFresh: !!checked }))}
              />
              <Label htmlFor="isFresh" className="cursor-pointer">Produit Frais</Label>
            </div>
            <div className="flex items-center gap-2">
              <Checkbox
                id="is_active"
                checked={form.is_active}
                onCheckedChange={(checked) => setForm((prev) => ({ ...prev, is_active: !!checked }))}
              />
              <Label htmlFor="is_active" className="cursor-pointer">Actif (visible dans l'app)</Label>
            </div>
          </div>

          <DialogFooter>
            <Button type="button" variant="outline" onClick={() => onOpenChange(false)}>Annuler</Button>
            <Button type="submit" disabled={loading}>
              {loading ? <><Loader2 className="mr-2 h-4 w-4 animate-spin" />Enregistrement...</> : isEdit ? 'Modifier' : 'Créer'}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  )
}

export default ProductForm
