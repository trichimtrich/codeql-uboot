import cpp


class NetworkByteSwap extends Expr {
  NetworkByteSwap () {
    // TODO: replace <class> and <var>
    exists(MacroInvocation mi, Macro m |
      mi.getExpr() = this and
      m = mi.getMacro() and
      m.getName().regexpMatch("ntoh.*")
    )
  }
}

from NetworkByteSwap n
select n, "Network byte swap"