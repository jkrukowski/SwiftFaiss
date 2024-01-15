import SwiftFaissC

public enum QuantizerType {
    case QT8bit
    case QT4bit
    case QT8bitUniform
    case QT4bitUniform
    case QTFp16
    case QT8bitDirect
    case QT6bit

    var faissQuantizerType: FaissQuantizerType {
        switch self {
        case .QT8bit:
            QT_8bit
        case .QT4bit:
            QT_4bit
        case .QT8bitUniform:
            QT_8bit_uniform
        case .QT4bitUniform:
            QT_4bit_uniform
        case .QTFp16:
            QT_fp16
        case .QT8bitDirect:
            QT_8bit_direct
        case .QT6bit:
            QT_6bit
        }
    }
}
