import { useState, useEffect, useMemo } from 'react'
import DataTable from '@/components/DataTable'
import CategoryForm from '@/components/CategoryForm'
import { Button } from '@/components/ui/button'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from '@/components/ui/alert-dialog'
import { MoreHorizontal, Plus, Pencil, Trash2 } from 'lucide-react'
import { getCategories, deleteCategory } from '@/services/api'
import { toast } from 'sonner'

const Categories = () => {
  const [categories, setCategories] = useState([])
  const [loading, setLoading] = useState(true)
  const [formOpen, setFormOpen] = useState(false)
  const [editCategory, setEditCategory] = useState(null)
  const [deleteId, setDeleteId] = useState(null)

  const load = () => {
    setLoading(true)
    getCategories()
      .then((data) => setCategories(data.data ?? []))
      .catch((e) => toast.error(e.message))
      .finally(() => setLoading(false))
  }

  useEffect(load, [])

  const handleDelete = async () => {
    try {
      await deleteCategory(deleteId)
      toast.success('Catégorie supprimée')
      setDeleteId(null)
      load()
    } catch (e) {
      toast.error(e.message)
    }
  }

  const openEdit = (cat) => {
    setEditCategory(cat)
    setFormOpen(true)
  }

  const openCreate = () => {
    setEditCategory(null)
    setFormOpen(true)
  }

  const columns = useMemo(() => [
    {
      accessorKey: 'icon',
      header: 'Icône',
      cell: ({ getValue }) => <span className="text-2xl">{getValue() || '—'}</span>,
    },
    {
      accessorKey: 'name',
      header: 'Nom',
      cell: ({ getValue }) => <span className="font-medium">{getValue()}</span>,
    },
    {
      accessorKey: 'order',
      header: 'Ordre',
      cell: ({ getValue }) => <span className="text-muted-foreground">{getValue() ?? 0}</span>,
    },
    {
      id: 'actions',
      header: 'Actions',
      cell: ({ row }) => (
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="ghost" size="icon"><MoreHorizontal className="h-4 w-4" /></Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end">
            <DropdownMenuItem onClick={() => openEdit(row.original)}>
              <Pencil className="mr-2 h-4 w-4" />Modifier
            </DropdownMenuItem>
            <DropdownMenuItem onClick={() => setDeleteId(row.original.id)} className="text-destructive focus:text-destructive">
              <Trash2 className="mr-2 h-4 w-4" />Supprimer
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      ),
    },
  ], [])

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <p className="text-sm text-muted-foreground">{categories.length} catégorie(s)</p>
        <Button onClick={openCreate}><Plus className="mr-2 h-4 w-4" />Nouvelle catégorie</Button>
      </div>

      <DataTable
        columns={columns}
        data={categories}
        loading={loading}
        emptyMessage="Aucune catégorie"
      />

      <CategoryForm
        category={editCategory}
        open={formOpen}
        onOpenChange={setFormOpen}
        onSaved={() => { setFormOpen(false); load() }}
      />

      <AlertDialog open={!!deleteId} onOpenChange={(open) => !open && setDeleteId(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Supprimer la catégorie ?</AlertDialogTitle>
            <AlertDialogDescription>Cette action est irréversible.</AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Annuler</AlertDialogCancel>
            <AlertDialogAction onClick={handleDelete} className="bg-destructive text-destructive-foreground hover:bg-destructive/90">
              Supprimer
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  )
}

export default Categories
