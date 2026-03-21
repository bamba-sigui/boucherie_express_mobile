import { useState, useEffect, useMemo } from 'react'
import { useSearchParams } from 'react-router-dom'
import DataTable from '@/components/DataTable'
import { Badge } from '@/components/ui/badge'
import { Input } from '@/components/ui/input'
import { Tabs, TabsList, TabsTrigger, TabsContent } from '@/components/ui/tabs'
import { Card, CardContent } from '@/components/ui/card'
import { AlertTriangle } from 'lucide-react'
import { getProducts, updateStock } from '@/services/api'
import { toast } from 'sonner'

const Stock = () => {
  const [products, setProducts] = useState([])
  const [loading, setLoading] = useState(true)
  const [searchParams] = useSearchParams()
  const defaultTab = searchParams.get('filter') === 'out_of_stock' ? 'out' : 'all'
  const [editingId, setEditingId] = useState(null)
  const [editValue, setEditValue] = useState('')

  const load = () => {
    setLoading(true)
    getProducts()
      .then((data) => setProducts(data.data ?? []))
      .catch((e) => toast.error(e.message))
      .finally(() => setLoading(false))
  }

  useEffect(load, [])

  const handleStockSave = async (id) => {
    const newStock = parseInt(editValue)
    if (isNaN(newStock) || newStock < 0) {
      toast.error('Valeur invalide')
      setEditingId(null)
      return
    }
    try {
      await updateStock(id, newStock)
      setProducts((prev) => prev.map((p) => (p.id === id ? { ...p, stock: newStock } : p)))
      toast.success('Stock mis à jour')
    } catch (e) {
      toast.error(e.message)
    }
    setEditingId(null)
  }

  const outOfStock = products.filter((p) => p.stock === 0)
  const lowStock = products.filter((p) => p.stock >= 1 && p.stock <= 5)
  const okStock = products.filter((p) => p.stock > 5)

  const columns = useMemo(() => [
    {
      accessorKey: 'name',
      header: 'Produit',
      cell: ({ row }) => (
        <div className="flex items-center gap-3">
          {row.original.image_url ? (
            <img src={row.original.image_url} alt="" className="w-8 h-8 rounded object-cover" />
          ) : (
            <div className="w-8 h-8 rounded bg-muted flex items-center justify-center text-sm">🥩</div>
          )}
          <span className="font-medium text-sm">{row.original.name}</span>
        </div>
      ),
    },
    {
      accessorKey: 'category',
      header: 'Catégorie',
      cell: ({ getValue }) => <span className="text-sm text-muted-foreground">{getValue()}</span>,
    },
    {
      accessorKey: 'stock',
      header: 'Stock',
      cell: ({ row }) => {
        const p = row.original
        if (editingId === p.id) {
          return (
            <Input
              type="number"
              min="0"
              value={editValue}
              onChange={(e) => setEditValue(e.target.value)}
              onBlur={() => handleStockSave(p.id)}
              onKeyDown={(e) => e.key === 'Enter' && handleStockSave(p.id)}
              className="w-20 h-8"
              autoFocus
            />
          )
        }
        return (
          <span
            className="cursor-pointer font-medium text-sm hover:underline"
            onClick={() => { setEditingId(p.id); setEditValue(String(p.stock)) }}
          >
            {p.stock}
          </span>
        )
      },
    },
    {
      id: 'status',
      header: 'Statut',
      cell: ({ row }) => {
        const stock = row.original.stock
        if (stock === 0) return <Badge variant="destructive">Rupture</Badge>
        if (stock <= 5) return <Badge variant="warning">Faible</Badge>
        return <Badge variant="success">OK</Badge>
      },
    },
  ], [editingId, editValue])

  const renderTable = (data) => (
    <DataTable
      columns={columns}
      data={data}
      loading={loading}
      emptyMessage="Aucun produit"
    />
  )

  return (
    <div className="space-y-4">
      {outOfStock.length > 0 && !loading && (
        <Card className="border-destructive/50 bg-destructive/5">
          <CardContent className="flex items-center gap-3 py-3">
            <AlertTriangle className="h-5 w-5 text-destructive shrink-0" />
            <p className="text-sm text-destructive">
              <strong>{outOfStock.length} produit(s)</strong> en rupture de stock
            </p>
          </CardContent>
        </Card>
      )}

      <Tabs defaultValue={defaultTab}>
        <TabsList>
          <TabsTrigger value="all">Tous ({products.length})</TabsTrigger>
          <TabsTrigger value="out" className="text-red-500 data-[state=active]:text-red-500">
            Rupture ({outOfStock.length})
          </TabsTrigger>
          <TabsTrigger value="low" className="text-yellow-500 data-[state=active]:text-yellow-500">
            Faible ({lowStock.length})
          </TabsTrigger>
          <TabsTrigger value="ok" className="text-green-500 data-[state=active]:text-green-500">
            OK ({okStock.length})
          </TabsTrigger>
        </TabsList>

        <TabsContent value="all">{renderTable(products)}</TabsContent>
        <TabsContent value="out">{renderTable(outOfStock)}</TabsContent>
        <TabsContent value="low">{renderTable(lowStock)}</TabsContent>
        <TabsContent value="ok">{renderTable(okStock)}</TabsContent>
      </Tabs>
    </div>
  )
}

export default Stock
