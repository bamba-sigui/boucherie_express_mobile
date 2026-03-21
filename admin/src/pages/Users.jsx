import { useState, useEffect } from 'react'
import DataTable from '@/components/DataTable'
import { Avatar, AvatarFallback } from '@/components/ui/avatar'
import { Badge } from '@/components/ui/badge'
import { getUsers } from '@/services/api'
import { toast } from 'sonner'

const columns = [
  {
    accessorKey: 'email',
    header: 'Utilisateur',
    cell: ({ row }) => {
      const email = row.original.email ?? '—'
      return (
        <div className="flex items-center gap-3">
          <Avatar className="h-8 w-8">
            <AvatarFallback className="bg-primary/20 text-primary text-xs font-bold">
              {email[0]?.toUpperCase() ?? '?'}
            </AvatarFallback>
          </Avatar>
          <span className="text-sm">{email}</span>
        </div>
      )
    },
  },
  {
    accessorKey: 'phone',
    header: 'Téléphone',
    cell: ({ getValue }) => <span className="text-sm text-muted-foreground">{getValue() ?? '—'}</span>,
  },
  {
    accessorKey: 'orders_count',
    header: 'Commandes',
    cell: ({ getValue }) => <span className="text-primary font-medium">{getValue() ?? 0}</span>,
  },
  {
    accessorKey: 'role',
    header: 'Rôle',
    cell: ({ getValue }) => {
      const role = getValue() ?? 'user'
      return <Badge variant={role === 'admin' ? 'default' : 'secondary'}>{role}</Badge>
    },
  },
  {
    accessorKey: 'created_at',
    header: 'Inscription',
    cell: ({ getValue }) => {
      const ts = getValue()
      if (!ts) return <span className="text-muted-foreground">—</span>
      const d = ts._seconds ? new Date(ts._seconds * 1000) : new Date(ts)
      return <span className="text-sm text-muted-foreground">{d.toLocaleDateString('fr-FR')}</span>
    },
  },
]

const Users = () => {
  const [users, setUsers] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    getUsers()
      .then((data) => setUsers(data.data ?? []))
      .catch((e) => toast.error(e.message))
      .finally(() => setLoading(false))
  }, [])

  return (
    <DataTable
      columns={columns}
      data={users}
      loading={loading}
      searchColumn="email"
      searchPlaceholder="Rechercher par email ou téléphone..."
      emptyMessage="Aucun utilisateur"
    />
  )
}

export default Users
