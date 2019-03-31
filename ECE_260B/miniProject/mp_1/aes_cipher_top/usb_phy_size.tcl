set design [get_attri [current_design] full_name]
set outFp [open ${design}_sizing.rpt w]

set initialWNS  [ PtWorstSlack clk ]
set initialLeak [ PtLeakPower ]
set capVio [ PtGetCapVio ]
set tranVio [ PtGetTranVio ]
puts "Initial slack:\t${initialWNS} ps"
puts "Initial leakage:\t${initialLeak} W"
puts "Final $capVio"
puts "Final $tranVio"
puts "======================================" 
puts $outFp "Initial slack:\t${initialWNS} ps"
puts $outFp "Initial leakage:\t${initialLeak} W"
puts $outFp "Final $capVio"
puts $outFp "Final $tranVio"
puts $outFp "======================================" 

#set cellList [ sort_collection [get_cells *] base_name]
set cellList [get_cells *]
set VtswapCnt 0
set SizeswapCnt 0

set flag [defineAttributes]
set newCellList [sortCellssensitivity $cellList]

foreach_in_collection cell $newCellList {
    set thisSensi [get_attri $cell Sensitivity]
    puts $outFp "-----${thisSensi}-------"
    if { $thisSensi > 0} {
        set cellName [get_attri $cell base_name]
        set libcell [get_lib_cells -of_objects $cellName]
        set libcellName [get_attri $libcell base_name]
        if {$libcellName == "ms00f80"} {
            continue
        }

        set newlibcellName [get_attri $cell SwapCell]
        size_cell $cellName $newlibcellName
        set newWNS [ PtWorstSlack clk ]
        if { $newWNS < 0.0 } {
            size_cell $cellName $libcellName
        } else {
            incr VtswapCnt
            set libcellName $newlibcellName
            puts $outFp "- cell ${cellName} is swapped to $newlibcellName"
        }
    }
}

set finalWNS  [ PtWorstSlack clk ]
set finalLeak [ PtLeakPower ]
set capVio [ PtGetCapVio ]
set tranVio [ PtGetTranVio ]
set improvment  [format "%.3f" [expr ( $initialLeak - $finalLeak ) / $initialLeak * 100.0]]
puts $outFp "======================================" 
puts $outFp "Final slack:\t${finalWNS} ps"
puts $outFp "Final leakage:\t${finalLeak} W"
puts $outFp "Final $capVio"
puts $outFp "Final $tranVio"
puts $outFp "#Vt cell swaps:\t${VtswapCnt}"
puts $outFp "#Cell size swaps:\t${SizeswapCnt}"
puts $outFp "Leakage improvment\t${improvment} %"

close $outFp    
