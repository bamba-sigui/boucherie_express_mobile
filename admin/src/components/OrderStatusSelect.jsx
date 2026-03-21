import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { Badge } from '@/components/ui/badge'

export const STATUS_OPTIONS = [
  { value: 'pending', label: 'En attente', variant: 'warning' },
  { value: 'confirmed', label: 'Confirmée', variant: 'info' },
  { value: 'preparing', label: 'En préparation', variant: 'secondary' },
  { value: 'delivering', label: 'En livraison', variant: 'default' },
  { value: 'delivered', label: 'Livrée', variant: 'success' },
  { value: 'cancelled', label: 'Annulée', variant: 'destructive' },
]

export const StatusBadge = ({ status }) => {
  const opt = STATUS_OPTIONS.find((o) => o.value === status)
  if (!opt) return <Badge variant="secondary">{status}</Badge>
  return <Badge variant={opt.variant}>{opt.label}</Badge>
}

const OrderStatusSelect = ({ value, onChange, disabled = false }) => (
  <Select value={value} onValueChange={onChange} disabled={disabled}>
    <SelectTrigger className="w-[160px] h-8 text-xs">
      <SelectValue />
    </SelectTrigger>
    <SelectContent>
      {STATUS_OPTIONS.map((opt) => (
        <SelectItem key={opt.value} value={opt.value}>
          {opt.label}
        </SelectItem>
      ))}
    </SelectContent>
  </Select>
)

export default OrderStatusSelect
