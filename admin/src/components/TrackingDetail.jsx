import { useState, useEffect } from 'react'
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetDescription } from '@/components/ui/sheet'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Button } from '@/components/ui/button'
import { Separator } from '@/components/ui/separator'
import { Loader2 } from 'lucide-react'
import TrackingTimeline, { STEPS, STATUS_INDEX } from './TrackingTimeline'
import { getTracking, updateTracking, updateOrderStatus } from '@/services/api'
import { toast } from 'sonner'

const STEP_TO_STATUS = { pending: 'pending', preparing: 'preparing', delivering: 'delivering', delivered: 'delivered' }

const TrackingDetail = ({ order, open, onOpenChange, onUpdated }) => {
  const [tracking, setTracking] = useState(null)
  const [loading, setLoading] = useState(false)
  const [saving, setSaving] = useState(false)
  const [deliverer, setDeliverer] = useState('')
  const [eta, setEta] = useState('')

  useEffect(() => {
    if (!order || !open) return
    setLoading(true)
    getTracking(order.id)
      .then((data) => {
        setTracking(data)
        setDeliverer(data.deliverer ?? '')
        setEta(data.eta ?? '')
      })
      .catch(() => {
        setTracking(null)
        setDeliverer('')
        setEta('')
      })
      .finally(() => setLoading(false))
  }, [order, open])

  const handleStepClick = async (stepKey, stepIndex) => {
    const currentIdx = STATUS_INDEX[order.status] ?? -1
    if (stepIndex <= currentIdx) return

    const newStatus = STEP_TO_STATUS[stepKey]
    if (!newStatus) return

    setSaving(true)
    try {
      await updateOrderStatus(order.id, newStatus)
      const now = new Date().toLocaleString('fr-FR')
      setTracking((prev) => ({
        ...prev,
        timestamps: { ...(prev?.timestamps ?? {}), [stepKey]: now },
      }))
      onUpdated?.(order.id, newStatus)
      toast.success(`Statut avancé : ${STEPS[stepIndex].label}`)
    } catch (e) {
      toast.error(e.message)
    } finally {
      setSaving(false)
    }
  }

  const handleSaveInfo = async () => {
    setSaving(true)
    try {
      await updateTracking(order.id, { deliverer, eta })
      toast.success('Informations mises à jour')
    } catch (e) {
      toast.error(e.message)
    } finally {
      setSaving(false)
    }
  }

  if (!order) return null

  return (
    <Sheet open={open} onOpenChange={onOpenChange}>
      <SheetContent className="w-full sm:max-w-md overflow-y-auto">
        <SheetHeader>
          <SheetTitle>Suivi commande</SheetTitle>
          <SheetDescription className="font-mono">#{order.id?.slice(0, 8).toUpperCase()}</SheetDescription>
        </SheetHeader>

        <div className="mt-6 space-y-6">
          {loading ? (
            <div className="flex justify-center py-8">
              <Loader2 className="h-6 w-6 animate-spin text-muted-foreground" />
            </div>
          ) : (
            <>
              <TrackingTimeline
                status={order.status}
                timestamps={tracking?.timestamps ?? {}}
                onStepClick={handleStepClick}
              />

              <Separator />

              <div className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="deliverer">Livreur</Label>
                  <Input
                    id="deliverer"
                    value={deliverer}
                    onChange={(e) => setDeliverer(e.target.value)}
                    placeholder="Nom du livreur"
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="eta">Heure estimée (ETA)</Label>
                  <Input
                    id="eta"
                    value={eta}
                    onChange={(e) => setEta(e.target.value)}
                    placeholder="Ex: 14h30"
                  />
                </div>
                <Button onClick={handleSaveInfo} disabled={saving} className="w-full">
                  {saving ? <Loader2 className="mr-2 h-4 w-4 animate-spin" /> : null}
                  Enregistrer
                </Button>
              </div>
            </>
          )}
        </div>
      </SheetContent>
    </Sheet>
  )
}

export default TrackingDetail
