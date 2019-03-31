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

set cellList [ sort_collection [get_cells *] base_name]
# set cellList [get_cells *]
set VtswapCnt 0
set SizeswapCnt 0

# ========================= creating dictionary
set dicts [dict create]; # Creating empty dictionary
set fp [open cellInfo.txt r]
while {[gets $fp line]!=-1} {
    [regexp {(\S+).*} $line match name ]
    set x $name
    [regexp {(\d+\.\d+)} $line match value ]
    set y $value
    # puts $outFp "name : ${x}"
    # puts $outFp "value: ${y}"
    dict lappend dicts $name $value
}
close $fp
# =========================
set flag [defineAttributes]
set newCellList [sortCellssensitivity $cellList $dicts]
#exitset newCellList [col2list $newCellList]
set condition 1
# puts $outFp "------[llength $newCellList]-------"
while { $condition } {
    foreach_in_collection cell $newCellList {
        #set cell [lindex $newCellList 0]
        set thisSensi [get_attri $cell Sensitivity]
        # puts $outFp "------${thisSensi}-------"
        if { $thisSensi > 0} {
            set cellName [get_attri $cell base_name]
            set libcell [get_lib_cells -of_objects $cellName]
            set libcellName [get_attri $libcell base_name]
            if {$libcellName == "ms00f80"} {
                continue
            }

            set newlibcellName [get_attri $cell SwapCell]
            size_cell $cellName $newlibcellName
            set valid [check $cellName]
            if { !$valid } {
                size_cell $cellName $libcellName
                set_user_attribute $cell Sensitivity 0.0
            } else {
                if { $newlibcellName == [get_attri $cell VtCell] } {
                    incr VtswapCnt
                } else {
                    incr SizeswapCnt
                }
                set libcellName $newlibcellName
                puts $outFp "- cell ${cellName} is swapped to $newlibcellName"

                set_user_attribute $cell Sensitivity [getSensitivity $cell $dicts]
                
            }
            set newCellList [sort_collection -descending $newCellList {Sensitivity}]
            break
        } else {
            set condition 0
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
