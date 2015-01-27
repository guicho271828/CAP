#!/bin/bash

export FD_DIR=$(dirname $(readlink -ef $0))/downward

#### iterated
# ./component-planner \
#     --dynamic-space-size 2000 \
#     --debug-preprocessing \
#     --default --both-search fd-clean "--alias seq-sat-lama-2011" \
#     -t 15 -m 500000 test/assembly-mixed/p20.pddl

#### lama 1st iteration

    # --debug-preprocessing \

./component-planner \
    --dynamic-space-size 2000 \
    --default --both-search fd-clean \
    "$(cat <<EOF
--search-options
--if-unit-cost
--heuristic hlm,hff=lm_ff_syn(lm_rhw(reasonable_orders=true))
--search lazy_greedy([hff,hlm],preferred=[hff,hlm])
--if-non-unit-cost
--heuristic hlm1,hff1=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=one,cost_type=one))
--search lazy_greedy([hff1,hlm1],preferred=[hff1,hlm1],cost_type=one,reopen_closed=false)
--always
EOF
)" -t 60 -m 500000 test/assembly-mixed/p20.pddl

./component-planner \
    --dynamic-space-size 2000 \
    --remove-component-problem-cost \
    --remove-main-problem-cost \
    --default --both-search ff-clean - \
    -t 60 -m 2000000 test/assembly-mixed/p20.pddl

./component-planner \
    --dynamic-space-size 2000 \
    --default \
    --both-search fd-clean "--search-options --search lazy_greedy(cea())" \
    -t 60 -m 2000000 test/assembly-mixed/p20.pddl
