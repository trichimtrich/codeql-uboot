import cpp
import semmle.code.cpp.dataflow.TaintTracking
import DataFlow::PathGraph

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

class Config extends TaintTracking::Configuration {
    Config() {
        this = "NetworkToMemFuncLength"
    }

    override predicate isSource(DataFlow::Node source) {
        source.asExpr() instanceof NetworkByteSwap
    }

    override predicate isSink(DataFlow::Node sink) {
        exists(FunctionCall fc, Function f |
            f = fc.getTarget() and
            f.getName() = "memcpy" and
            fc.getArgument(2) = sink.asExpr()
        )
    }
}

from Config cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink, source, sink, "Network byte swap flows to memcpy"