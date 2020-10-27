* Survey Data Analysis with Stata

use "https://github.com/CenterOnBudget/stata-trainings/raw/master/penguins-dta/penguins.dta", clear

generate weight = round(runiform(100, 1000))
forvalues r = 1/80 {
  generate weight`r' = round(runiform(100, 1000))
}

help svyset##description

svyset [pw=weight], vce(sdr) sdrweight(weight1-weight80) mse

set level 90                        

svy: mean bill_length_mm

return list
ereturn list

svy: total body_mass_g

display %13.0gc e(b)[1,1]

svy: proportion species

help factor variable

svy: proportion species#island

svy: proportion species##island

svy: mean i.species
svy: mean i.species#i.island
svy: mean i.species##i.island

svy: total i.species

help svy: tabulate

svy: mean bill_length_mm bill_depth_mm body_mass_g

misstable patterns bill_length_mm bill_depth_mm body_mass_g, frequency asis 

svy: mean bill_length_mm, over(species)

svy: mean bill_length_mm, over(species island)

codebook sex
generate female = sex == 1 if !missing(sex)
svy, subpop(female): mean bill_length_mm

svy, subpop(if species == 2 & year == 2009): mean bill_length_mm

svy, subpop(female): mean bill_length_mm, over(species)

svy: mean bill_length_mm, over(species)
estat cv

help test

svy, subpop(if species == 2 & year == 2009): mean flipper_length_mm, over(sex) coeflegend

test _b[c.flipper_length_mm@1bn.sex] = _b[c.flipper_length_mm@2.sex]

return list

local significant_diff = `r(p)' <= 0.1    // 1 if true, 0 if false
display `significant_diff'

