import { useState } from 'react'
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from '@/components/ui/dialog'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Button } from '@/components/ui/button'
import { Loader2 } from 'lucide-react'
import { createCategory, updateCategory } from '@/services/api'
import { toast } from 'sonner'

const CategoryForm = ({ category, open, onOpenChange, onSaved }) => {
  const isEdit = !!category

  const [form, setForm] = useState({
    name: category?.name ?? '',
    icon: category?.icon ?? '',
    order: category?.order ?? 0,
  })
  const [loading, setLoading] = useState(false)

  const handleChange = (e) => {
    setForm((prev) => ({ ...prev, [e.target.name]: e.target.value }))
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setLoading(true)
    try {
      const body = { name: form.name, icon: form.icon, order: parseInt(form.order) }
      isEdit ? await updateCategory(category.id, body) : await createCategory(body)
      toast.success(isEdit ? 'Catégorie modifiée' : 'Catégorie créée')
      onSaved()
    } catch (err) {
      toast.error(err.message)
    } finally {
      setLoading(false)
    }
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-sm">
        <DialogHeader>
          <DialogTitle>{isEdit ? 'Modifier la catégorie' : 'Nouvelle catégorie'}</DialogTitle>
        </DialogHeader>

        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="space-y-2">
            <Label htmlFor="cat-name">Nom *</Label>
            <Input id="cat-name" name="name" value={form.name} onChange={handleChange} required placeholder="Ex: Boeuf" />
          </div>

          <div className="space-y-2">
            <Label htmlFor="cat-icon">Icône (emoji)</Label>
            <Input id="cat-icon" name="icon" value={form.icon} onChange={handleChange} placeholder="🥩" />
          </div>

          <div className="space-y-2">
            <Label htmlFor="cat-order">Ordre</Label>
            <Input id="cat-order" type="number" name="order" value={form.order} onChange={handleChange} min="0" />
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

export default CategoryForm
