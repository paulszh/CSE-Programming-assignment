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

set cellList [sort_collection [get_cells *] base_name]
set VtswapCnt 0
set SizeswapCnt 0
foreach_in_collection cell $cellList {
    set cellName [get_attri $cell base_name]
    set libcell [get_lib_cells -of_objects $cellName]
    set libcellName [get_attri $libcell base_name]
    if {$libcellName == "ms00f80"} {
        continue
    }
    #Vt cell swap example (convert all fast cells (i.e. LVT) to medium cells (i.e. NVT)...
    if { [regexp {[a-z][a-z][0-9][0-9]f[0-9][0-9]} $libcellName] } { 
        set newlibcellName [string replace $libcellName 4 4 m] 
        size_cell $cellName $newlibcellName
        
        set newWNS [ PtWorstSlack clk ]
        if { $newWNS < 0.0 } {
            size_cell $cellName $libcellName
            if { [regexp {[a-z][a-z][0-9][0-9][smf]04} $libcellName] } {
                set newlibcellName [string replace $libcellName 5 6 "03"]
                size_cell $cellName $newlibcellName

                set newWNS [ PtWorstSlack clk ]
                if { $newWNS < 0.0 } {
                    size_cell $cellName $libcellName
                } else {
                    incr SizeswapCnt
                    set libcellName $newlibcellName
                    puts $outFp "- cell ${cellName} is swapped to $newlibcellName"
                }
            }
            if { [regexp {[a-z][a-z][0-9][0-9][smf]03} $libcellName] } {
                set newlibcellName [string replace $libcellName 5 6 "02"]
                size_cell $cellName $newlibcellName

                set newWNS [ PtWorstSlack clk ]
                if { $newWNS < 0.0 } {
                    size_cell $cellName $libcellName
                } else {
                    incr SizeswapCnt
                    set libcellName $newlibcellName
                    puts $outFp "- cell ${cellName} is swapped to $newlibcellName"
                }
            }

            if { [regexp {[a-z][a-z][0-9][0-9][smf]02} $libcellName] } {
                set newlibcellName [string replace $libcellName 5 6 "01"]
                size_cell $cellName $newlibcellName

                set newWNS [ PtWorstSlack clk ]
                if { $newWNS < 0.0 } {
                    size_cell $cellName $libcellName
                } else {
                    incr SizeswapCnt
                    set libcellName $newlibcellName
                    puts $outFp "- cell ${cellName} is swapped to $newlibcellName"
                }
            }
        } else {
            incr VtswapCnt
            set libcellName $newlibcellName
            puts $outFp "- cell ${cellName} is swapped to $newlibcellName"
        }
    }
    
    #Vt cell swap (convert all medium cells (i.e. NVT) to slow cells (i.e. HVT)...
    if { [regexp {[a-z][a-z][0-9][0-9]m[0-9][0-9]} $libcellName] } { 
        set newlibcellName [string replace $libcellName 4 4 s] 
        size_cell $cellName $newlibcellName
        
        set newWNS [ PtWorstSlack clk ]
        if { $newWNS < 0.1 } {
            size_cell $cellName $libcellName
            if { [regexp {[a-z][a-z][0-9][0-9][smf]03} $libcellName] } {
                set newlibcellName [string replace $libcellName 5 6 "02"]
                size_cell $cellName $newlibcellName

                set newWNS [ PtWorstSlack clk ]
                if { $newWNS < 0.0 } {
                    size_cell $cellName $libcellName
                } else {
                    incr SizeswapCnt
                    set libcellName $newlibcellName
                    puts $outFp "- cell ${cellName} is swapped to $newlibcellName"
                }
            }
            if { [regexp {[a-z][a-z][0-9][0-9][smf]02} $libcellName] } {
                set newlibcellName [string replace $libcellName 5 6 "01"]
                size_cell $cellName $newlibcellName

                set newWNS [ PtWorstSlack clk ]
                if { $newWNS < 0.0 } {
                    size_cell $cellName $libcellName
                } else {
                    incr SizeswapCnt
                    set libcellName $newlibcellName
                    puts $outFp "- cell ${cellName} is swapped to $newlibcellName"
                }
            }
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


