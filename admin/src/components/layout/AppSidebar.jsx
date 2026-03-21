import { useState } from 'react'
import { NavLink } from 'react-router-dom'
import { cn } from '@/lib/utils'
import { Button } from '@/components/ui/button'
import { Separator } from '@/components/ui/separator'
import { Tooltip, TooltipContent, TooltipTrigger, TooltipProvider } from '@/components/ui/tooltip'
import {
  LayoutDashboard,
  Package,
  Tags,
  Warehouse,
  ShoppingCart,
  Truck,
  Users,
  PanelLeftClose,
  PanelLeft,
  LogOut,
} from 'lucide-react'
import { useAuth } from '@/context/AuthContext'

const NAV_ITEMS = [
  { to: '/', label: 'Dashboard', icon: LayoutDashboard },
  { to: '/products', label: 'Produits', icon: Package },
  { to: '/categories', label: 'Catégories', icon: Tags },
  { to: '/stock', label: 'Stock', icon: Warehouse },
  { to: '/orders', label: 'Commandes', icon: ShoppingCart },
  { to: '/tracking', label: 'Livraisons', icon: Truck },
  { to: '/users', label: 'Clients', icon: Users },
]

const AppSidebar = () => {
  const [collapsed, setCollapsed] = useState(false)
  const { logout } = useAuth()

  return (
    <TooltipProvider delayDuration={0}>
      <aside
        className={cn(
          'hidden md:flex flex-col h-screen border-r bg-card transition-all duration-300',
          collapsed ? 'w-16' : 'w-64'
        )}
      >
        {/* Logo */}
        <div className="flex items-center h-14 px-4 border-b">
          <span className="text-xl">🥩</span>
          {!collapsed && <span className="ml-2 font-bold text-foreground truncate">Boucherie Express</span>}
        </div>

        {/* Navigation */}
        <nav className="flex-1 py-4 space-y-1 px-2 overflow-y-auto">
          {NAV_ITEMS.map((item) => {
            const Icon = item.icon
            const link = (
              <NavLink
                key={item.to}
                to={item.to}
                end={item.to === '/'}
                className={({ isActive }) =>
                  cn(
                    'flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium transition-colors',
                    isActive
                      ? 'bg-primary text-primary-foreground'
                      : 'text-muted-foreground hover:bg-accent hover:text-accent-foreground'
                  )
                }
              >
                <Icon className="h-4 w-4 shrink-0" />
                {!collapsed && <span className="truncate">{item.label}</span>}
              </NavLink>
            )

            if (collapsed) {
              return (
                <Tooltip key={item.to}>
                  <TooltipTrigger asChild>{link}</TooltipTrigger>
                  <TooltipContent side="right">{item.label}</TooltipContent>
                </Tooltip>
              )
            }

            return link
          })}
        </nav>

        <Separator />

        {/* Footer */}
        <div className="p-2 space-y-1">
          {collapsed ? (
            <Tooltip>
              <TooltipTrigger asChild>
                <Button variant="ghost" size="icon" onClick={logout} className="w-full text-muted-foreground hover:text-destructive">
                  <LogOut className="h-4 w-4" />
                </Button>
              </TooltipTrigger>
              <TooltipContent side="right">Déconnexion</TooltipContent>
            </Tooltip>
          ) : (
            <Button variant="ghost" onClick={logout} className="w-full justify-start text-muted-foreground hover:text-destructive">
              <LogOut className="h-4 w-4 mr-2" />
              Déconnexion
            </Button>
          )}

          {collapsed ? (
            <Tooltip>
              <TooltipTrigger asChild>
                <Button variant="ghost" size="icon" onClick={() => setCollapsed(false)} className="w-full text-muted-foreground">
                  <PanelLeft className="h-4 w-4" />
                </Button>
              </TooltipTrigger>
              <TooltipContent side="right">Étendre</TooltipContent>
            </Tooltip>
          ) : (
            <Button variant="ghost" onClick={() => setCollapsed(true)} className="w-full justify-start text-muted-foreground">
              <PanelLeftClose className="h-4 w-4 mr-2" />
              Réduire
            </Button>
          )}
        </div>
      </aside>
    </TooltipProvider>
  )
}

export default AppSidebar
