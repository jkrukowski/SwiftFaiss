import SwiftFaissC

public enum MetricType {
    case innerProduct
    case l2
    case l1
    case linf
    case lp
    case canberra
    case brayCurtis
    case jensenShannon

    init(_ faissMetricType: FaissMetricType) {
        switch faissMetricType {
        case METRIC_INNER_PRODUCT:
            self = .innerProduct
        case METRIC_L2:
            self = .l2
        case METRIC_L1:
            self = .l1
        case METRIC_Linf:
            self = .linf
        case METRIC_Lp:
            self = .lp
        case METRIC_Canberra:
            self = .canberra
        case METRIC_BrayCurtis:
            self = .brayCurtis
        case METRIC_JensenShannon:
            self = .jensenShannon
        default:
            fatalError("Unknown metric type")
        }
    }

    var faissMetricType: FaissMetricType {
        switch self {
        case .innerProduct:
            METRIC_INNER_PRODUCT
        case .l2:
            METRIC_L2
        case .l1:
            METRIC_L1
        case .linf:
            METRIC_Linf
        case .lp:
            METRIC_Lp
        case .canberra:
            METRIC_Canberra
        case .brayCurtis:
            METRIC_BrayCurtis
        case .jensenShannon:
            METRIC_JensenShannon
        }
    }
}
