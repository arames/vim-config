" Correctly indent the ternary operator.
if (!exists("*CppIndentDepth"))
    function CppIndentDepth()
        let lineno = v:lnum
        let lastQuestionMark = match(getline(lineno-1), "?[^?]*")
        if lastQuestionMark != -1
            return lastQuestionMark
        endif
        return cindent(lineno)
    endfunction
endif

set indentexpr=CppIndentDepth()
