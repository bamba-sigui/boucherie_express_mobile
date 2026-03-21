import { useState, useEffect, useMemo } from 'react'
import DataTable from '@/components/DataTable'
import ProductForm from '@/components/ProductForm'
import { Badge } from '@/components/ui/badge'
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
import { getProducts, getCategories, deleteProduct } from '@/services/api'
import { toast } from 'sonner'

const fmt = (n) =>
  new Intl.NumberFormat('fr-CI', { style: 'currency', currency: 'XOF', maximumFractionDigits: 0 }).format(n)

const Products = () => {
  const [products, setProducts] = useState([])
  const [categories, setCategories] = useState([])
  const [loading, setLoading] = useState(true)
  const [formOpen, setFormOpen] = useState(false)
  const [editProduct, setEditProduct] = useState(null)
  const [deleteId, setDeleteId] = useState(null)

  const categoryMap = useMemo(() => {
    const map = {}
    categories.forEach((c) => { map[c.id] = c.name })
    return map
  }, [categories])

  const load = () => {
    setLoading(true)
    Promise.all([getProducts(), getCategories()])
      .then(([prodRes, catRes]) => {
        setProducts(prodRes.data ?? [])
        setCategories(catRes.data ?? [])
      })
      .catch((e) => toast.error(e.message))
      .finally(() => setLoading(false))
  }

  useEffect(load, [])

  const handleDelete = async () => {
    try {
      await deleteProduct(deleteId)
      toast.success('Produit supprimé')
      setDeleteId(null)
      load()
    } catch (e) {
      toast.error(e.message)
    }
  }

  const openEdit = (product) => {
    setEditProduct(product)
    setFormOpen(true)
  }

  const openCreate = () => {
    setEditProduct(null)
    setFormOpen(true)
  }

  const columns = useMemo(() => [
    {
      accessorKey: 'name',
      header: 'Produit',
      cell: ({ row }) => {
        const p = row.original
        const img = p.images?.[0] ?? p.image_url
        return (
          <div className="flex items-center gap-3">
            {img ? (
              <img src={img} alt="" className="w-10 h-10 rounded-lg object-cover" />
            ) : (
              <div className="w-10 h-10 rounded-lg bg-muted flex items-center justify-center text-lg">🥩</div>
            )}
            <div>
              <p className="text-sm font-medium">{p.name}</p>
              <p className="text-xs text-muted-foreground truncate max-w-[200px]">{p.description}</p>
            </div>
          </div>
        )
      },
    },
    {
      accessorKey: 'category_id',
      header: 'Catégorie',
      cell: ({ getValue }) => {
        const name = categoryMap[getValue()]
        return <span className="text-sm">{name ?? '—'}</span>
      },
    },
    {
      accessorKey: 'price',
      header: 'Prix',
      cell: ({ getValue }) => <span className="text-primary font-medium text-sm">{fmt(getValue())}</span>,
    },
    {
      accessorKey: 'stock',
      header: 'Stock',
      cell: ({ getValue }) => {
        const stock = getValue()
        const variant = stock === 0 ? 'destructive' : stock < 5 ? 'warning' : 'success'
        return <Badge variant={variant}>{stock}</Badge>
      },
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
  ], [categoryMap])

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <p className="text-sm text-muted-foreground">{products.length} produit(s)</p>
        <Button onClick={openCreate}><Plus className="mr-2 h-4 w-4" />Nouveau produit</Button>
      </div>

      <DataTable
        columns={columns}
        data={products}
        loading={loading}
        searchColumn="name"
        searchPlaceholder="Rechercher un produit..."
        emptyMessage="Aucun produit"
      />

      <ProductForm
        product={editProduct}
        open={formOpen}
        onOpenChange={setFormOpen}
        onSaved={() => { setFormOpen(false); load() }}
      />

      <AlertDialog open={!!deleteId} onOpenChange={(open) => !open && setDeleteId(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Supprimer le produit ?</AlertDialogTitle>
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

export default Products
