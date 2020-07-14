defmodule Dispatcher do
  use Matcher
  define_accept_types []

  get "/schema-analysis-jobs/:id/run", _ do
    forward conn, [], "http://shmdoc-analyzer/schema-analysis-jobs/" <> id <> "/run"
  end

  match "/schema-analysis-jobs/*path", _ do
    forward conn, path, "http://resource/schema-analysis-jobs"
  end

  match "/columns/*path", _ do
    forward conn, path, "http://resource/columns/"
  end

  post "/files/*path", _ do
    forward conn, path, "http://file/files/"
  end

  get "/files/:id/download", _ do
    forward conn, [], "http://file/files/" <> id <> "/download"
  end

  delete "/files/*path", _ do
    forward conn, path, "http://file/files/"
  end

  match "/files/*path", _ do
    forward conn, path, "http://resource/files/"
  end

end
