//
//  File.swift
//  
//
//  Created by 顾艳华 on 2023/6/24.
//

import Foundation

public class TextLoader: BaseLoader {
    let filePath: String
    
    public init(filePath: String, callbacks: [BaseCallbackHandler] = []) {
        self.filePath = filePath
        super.init(callbacks: callbacks)
    }
    public override func loadDocuments() async throws  -> [Document] {
        let nameAndExt = self.filePath.split(separator: ".")
        let name = "\(nameAndExt[0])"
        let ext = "\(nameAndExt[1])"
        var text = ""
        if let res = Bundle.main.path(forResource: name, ofType: ext){
            text = try String(contentsOfFile: res)
            let metadata = ["source": self.filePath]
            return [Document(pageContent: text, metadata: metadata)]
        } else {
            throw LLMKitError.LoaderError("Text fail not exist")
        }
    }
    
    override func type() -> String {
        "Text"
    }
}
//class TextLoader(BaseLoader):
//    """Load text files.
//
//
//    Args:
//        filePath: Path to the file to load.
//
//        encoding: File encoding to use. If `None`, the file will be loaded
//        with the default system encoding.
//
//        autodetect_encoding: Whether to try to autodetect the file encoding
//            if the specified encoding fails.
//    """
//
//    def __init__(
//        self,
//        filePath: str,
//        encoding: Optional[str] = None,
//        autodetect_encoding: bool = False,
//    ):
//        """Initialize with file path."""
//        self.filePath = filePath
//        self.encoding = encoding
//        self.autodetect_encoding = autodetect_encoding
//
//    def load(self) -> List[Document]:
//        """Load from file path."""
//        text = ""
//        try:
//            with open(self.filePath, encoding=self.encoding) as f:
//                text = f.read()
//        except UnicodeDecodeError as e:
//            if self.autodetect_encoding:
//                detected_encodings = detect_file_encodings(self.filePath)
//                for encoding in detected_encodings:
//                    logger.debug("Trying encoding: ", encoding.encoding)
//                    try:
//                        with open(self.filePath, encoding=encoding.encoding) as f:
//                            text = f.read()
//                        break
//                    except UnicodeDecodeError:
//                        continue
//            else:
//                raise RuntimeError(f"Error loading {self.filePath}") from e
//        except Exception as e:
//            raise RuntimeError(f"Error loading {self.filePath}") from e
//
//        metadata = {"source": self.filePath}
//        return [Document(pageContent=text, metadata=metadata)]
