function coords = coord_fuselaje(parametros)


b = parametros.b;
h = parametros.h;
rsup = parametros.rsup;
rinf = parametros.rinf;

l1 = h - rsup - rinf;
l2 = b - 2 * rinf;
l4 = b - 2 * rsup;

coords = [l4/2      h/2;
          b/2       l1/2;
          b/2      -l1/2;
          l2/2     -h/2;
          -l2/2    -h/2;
          -b/2     -l1/2;
          -b/2      l1/2;
          -l4/2     h/2];
end