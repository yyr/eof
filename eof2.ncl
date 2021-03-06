begin
  neof   = 3        ; number of EOFs
  optEOF = True
  optEOF@jopt = 0   ; This is the default; most commonly used; no need to specify.
  optETS = False

  f      = addfile ("uv_jjas_anom_yr.nc", "r")
  u    = f->uwnd(:,0,:,:)
  v    = f->vwnd(:,0,:,:)

  dims = dimsizes(u)
  data = new((/dims(0),dims(1)*2,dims(2)/), typeof(u))

  data!0 = "time"
  data!1 = "lat"
  data!2 = "lon"

  data&time = u&time   ; is also =v&time
  ; data&lat = u&lat         ; is also =v&lat
  data&lon = u&lon        ; is also =v&lon

  vl = dims(1)
  vu = dims(1)*2 -1

  data(:,0:vl-1,:) = u
  data(:,vl:vu,:) = v

  eof      = eofunc_n_Wrap(data, neof, optEOF, 0)
  eof_ts   = eofunc_ts_n_Wrap(data, eof, optETS, 0)
  eof_ts_std = dim_standardize_n(eof_ts, 0, 1)      ; normalize

  a=addfile("eof2_u.nc", "c")
  a->EOF=eof(:,0:vl-1,:)      ;EOF Spatial Pattern

  a1=addfile("eof2_v.nc", "c")
  a1->EOF=eof(:,vl:vu,:)      ;EOF Spatial Pattern

  b=addfile("eof2_ts.nc", "c")
  b->EOFTS=eof_ts   ;EOF amplitude timeseries

  c=addfile("eof2_ts_std.nc", "c")
  c->EOFTSSTD=eof_ts_std ;EOF amplitude timeseries
end
