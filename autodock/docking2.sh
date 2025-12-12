#!/bin/bash
set -e

# === RECEPTOR ===
RECEPTOR="3O4O_out.pdbqt"

# === DOCKING PARAMETERS ===
CENTER_X=18.1500504
CENTER_Y=-0.3631765
CENTER_Z=10.4987311

SIZE_X=25
SIZE_Y=25
SIZE_Z=25

EXHAUSTIVENESS=9
NUM_MODES=3

echo "Looping through ligands in current folder ..."

for LIGAND in ./*.sdf; do
    NAME=$(basename "$LIGAND" .sdf)
    LIGAND_PDBQT="${NAME}.pdbqt"
    OUTPUT="${NAME}_docked2.pdbqt"
    LOG="${NAME}_log2.txt"
    CONFIG="${NAME}_config2.txt"

    echo "Preparing ligand: $NAME"

    mk_prepare_ligand.py \
        -i "$LIGAND" \
        -o "$LIGAND_PDBQT"

    echo "Creating config file for $NAME"
    cat > "$CONFIG" <<EOF
receptor = $RECEPTOR
ligand = $LIGAND_PDBQT

center_x = $CENTER_X
center_y = $CENTER_Y
center_z = $CENTER_Z

size_x = $SIZE_X
size_y = $SIZE_Y
size_z = $SIZE_Z

exhaustiveness = $EXHAUSTIVENESS
num_modes = $NUM_MODES
EOF

    echo "Docking ligand: $NAME"
    /Applications/ADVina/bin/vina --config "$CONFIG" --out "$OUTPUT" --log "$LOG"

done

echo "All dockings finished!"
