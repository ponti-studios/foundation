#!/bin/sh
mc mb --ignore-existing myminio/labyrinth
mc anonymous set public myminio/labyrinth
mc mb --ignore-existing myminio/storage
