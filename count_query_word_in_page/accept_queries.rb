def accept_queries
  Digdag.env.store(queries: queries)
end

def queries
  %w(aaaa ruby python)
end