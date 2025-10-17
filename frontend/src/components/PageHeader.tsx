type PageHeaderProps = {
  title: string
  subtitle?: string
}

export function PageHeader({ title, subtitle }: PageHeaderProps) {
  return (
    <header className="space-y-3 text-center">
      <h1 className="text-3xl font-semibold text-slate-900 sm:text-4xl">{title}</h1>
      {subtitle ? (
        <p className="mx-auto max-w-2xl text-base text-slate-600">{subtitle}</p>
      ) : null}
    </header>
  )
}
