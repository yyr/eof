begin
  neof   = 3        ; number of EOFs
  optEOF = True
  optEOF@jopt = 0   ; This is the default; most commonly used; no need to specify.
  optETS = False

  f      = addfile ("uv_jjas_anom_yr.nc", "r")
  u    = f->uwnd(:,0,:,:)
  v    = f->vwnd(:,0,:,:)

  printVarSummary(u)                              ; variable overview
  printVarSummary(v)

  data = new((/41,73,144,2/), typeof(u))

  data!0 = "time"
  data!1 = "lat"
  data!2 = "lon"
  data!3 = "component"

  data&time = u&time   ; is also =v&time
  data&lat = u&lat         ; is also =v&lat
  data&lon = u&lon        ; is also =v&lon
  ; data&component = (/"uwnd","vwnd"/)

  data(time|:,lat|:,lon|:,component|0) = u(time|:,lat|:,lon|:)
  data(time|:,lat|:,lon|:,component|1) = v(time|:,lat|:,lon|:)

  eof      = eofunc_n_Wrap(data, neof, optEOF, 0)
  eof_ts   = eofunc_ts_n_Wrap(data, eof, optETS, 0)
  eof_ts_std = dim_standardize_n( eof_ts, 0, 1)      ; normalize

  printVarSummary(eof )                         ; examine EOF variables
  printVarSummary(eof_ts)
  printVarSummary(eof_ts_std)

  a=addfile ("eof.nc", "c")
  a->EOF=eof      ;EOF Spatial Pattern
  b=addfile ("eof_ts.nc", "c")
  b->EOFTS=eof_ts   ;EOF amplitude timeseries
  c=addfile ("eof_ts_std.nc", "c")
  c->EOFTSSTD=eof_ts_std ;EOF amplitude timeseries
end
