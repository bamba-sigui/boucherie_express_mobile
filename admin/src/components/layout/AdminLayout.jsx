import AppSidebar from './AppSidebar'
import AppHeader from './AppHeader'
import MobileSidebar from './MobileSidebar'

const AdminLayout = ({ title, children }) => (
  <div className="flex h-screen overflow-hidden bg-background">
    <AppSidebar />
    <div className="flex flex-col flex-1 overflow-hidden">
      <header className="flex items-center justify-between h-14 border-b px-4 md:px-6 bg-card">
        <div className="flex items-center gap-2">
          <MobileSidebar />
          <h1 className="text-lg font-semibold text-foreground">{title}</h1>
        </div>
        <AppHeader />
      </header>
      <main className="flex-1 overflow-y-auto p-4 md:p-6">
        {children}
      </main>
    </div>
  </div>
)

export default AdminLayout
