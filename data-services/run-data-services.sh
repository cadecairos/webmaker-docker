if [ "$(uname)" == "Darwin" ]; then
    echo "OSX DETECTED"
    export PG_VOLUME_PATH=/Users/$USER/.config/webmaker/pg_data
    export MARIADB_VOLUME_PATH=/USERS/$USER/.config/webmaker/mariadb_data
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    echo "LINUX DETECTED"
    export PG_VOLUME_PATH=./pg_data
    export MARIADB_VOLUME_PATH=./mariadb_data
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    echo "WINDOWS DETECTED"
    export PG_VOLUME_PATH=$HOMEPATH/.config/webmaker/pg_data
    export MARIADB_VOLUME_PATH=$HOMEPATH/.config/webmaker/mariadb_data
fi

docker-compose up $1
