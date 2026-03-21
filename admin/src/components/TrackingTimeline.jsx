import { cn } from '@/lib/utils'
import { Check } from 'lucide-react'

const STEPS = [
  { key: 'pending', label: 'Commande reçue' },
  { key: 'preparing', label: 'En préparation' },
  { key: 'delivering', label: 'En livraison' },
  { key: 'delivered', label: 'Livrée' },
]

const STATUS_INDEX = { pending: 0, confirmed: 0, preparing: 1, delivering: 2, delivered: 3, cancelled: -1 }

const TrackingTimeline = ({ status, timestamps = {}, onStepClick }) => {
  const currentIdx = STATUS_INDEX[status] ?? -1

  return (
    <div className="space-y-0">
      {STEPS.map((step, i) => {
        const completed = i <= currentIdx && currentIdx !== -1
        const isCurrent = i === currentIdx
        const ts = timestamps[step.key]

        return (
          <div key={step.key} className="flex gap-4">
            {/* Line + Circle */}
            <div className="flex flex-col items-center">
              <button
                onClick={() => onStepClick?.(step.key, i)}
                className={cn(
                  'w-8 h-8 rounded-full flex items-center justify-center border-2 transition-colors shrink-0',
                  completed
                    ? 'bg-green-500 border-green-500 text-white'
                    : isCurrent
                      ? 'border-primary bg-primary/20 text-primary'
                      : 'border-muted-foreground/30 text-muted-foreground/30'
                )}
              >
                {completed ? <Check className="h-4 w-4" /> : <span className="text-xs">{i + 1}</span>}
              </button>
              {i < STEPS.length - 1 && (
                <div className={cn('w-0.5 h-12', completed ? 'bg-green-500' : 'bg-muted-foreground/20')} />
              )}
            </div>

            {/* Label */}
            <div className="pt-1">
              <p className={cn('text-sm font-medium', completed ? 'text-foreground' : 'text-muted-foreground')}>
                {step.label}
              </p>
              {ts && <p className="text-xs text-muted-foreground mt-0.5">{ts}</p>}
            </div>
          </div>
        )
      })}
    </div>
  )
}

export { STEPS, STATUS_INDEX }
export default TrackingTimeline
