export const STATUS_OPTIONS = [
  { value: 'pending',    label: 'En attente',      color: 'text-yellow-400',  bg: 'bg-yellow-400/10' },
  { value: 'confirmed',  label: 'Confirmée',        color: 'text-blue-400',    bg: 'bg-blue-400/10'   },
  { value: 'preparing',  label: 'En préparation',   color: 'text-purple-400',  bg: 'bg-purple-400/10' },
  { value: 'delivering', label: 'En livraison',     color: 'text-orange-400',  bg: 'bg-orange-400/10' },
  { value: 'delivered',  label: 'Livrée',           color: 'text-green-400',   bg: 'bg-green-400/10'  },
  { value: 'cancelled',  label: 'Annulée',          color: 'text-red-400',     bg: 'bg-red-400/10'    },
]

/** Badge statut en lecture seule */
export const StatusBadge = ({ status }) => {
  const opt = STATUS_OPTIONS.find((o) => o.value === status)
  if (!opt) return <span className="text-gray-400 text-xs">{status}</span>
  return (
    <span className={`inline-flex px-2 py-1 rounded-full text-xs font-medium ${opt.color} ${opt.bg}`}>
      {opt.label}
    </span>
  )
}

/** Select pour changer le statut */
const OrderStatusSelect = ({ value, onChange, disabled = false }) => (
  <select
    value={value}
    onChange={(e) => onChange(e.target.value)}
    disabled={disabled}
    className="bg-gray-800 border border-gray-700 text-white text-sm rounded-lg px-3 py-1.5
               focus:ring-orange-500 focus:border-orange-500 disabled:opacity-50 cursor-pointer"
  >
    {STATUS_OPTIONS.map((opt) => (
      <option key={opt.value} value={opt.value}>
        {opt.label}
      </option>
    ))}
  </select>
)

export default OrderStatusSelect
