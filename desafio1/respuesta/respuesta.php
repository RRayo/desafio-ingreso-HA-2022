<?php

/**
 * Reads a file and returns an array with the days with titans
 * If the file is not valid, it returns an empty array
 * @param string $file_name Name of the file to read
 * @return array Array with the days with titans
 */
function read_file($file_name)
{
    $data = [];
    $file = fopen($file_name, 'r');
    $raw_data = json_decode(fread($file, filesize($file_name)), true);
    fclose($file);

    if (!is_array($raw_data)) {
        print_r('The data is not valid: ' . json_encode($raw_data) . "\n");
        return [];
    }
    foreach ($raw_data as $item) {
        if (!is_array($item) || count($item) != 2) {
            print_r('The data is not valid: ' . json_encode($item) . "\n");
            return [];
        }
        $x = $item[0];
        $y = $item[1];
        $data = array_merge($data, range($x, $y - 1));
    }

    return $data;
}

/**
 * Returns the nearest day with the least titans and the amount of times it appears
 * If the array is empty, it returns [INF, INF]
 * @param array $data Data with the days with titans
 * @param callable|null $condition Condition to filter the days
 * @return array Array with the nearest day with the least titans and the amount of times it appears
 */
function get_nearest_day($data, $condition = null)
{
    if (empty($data)) {
        return [INF, INF];
    }
    $counter = array_count_values($data);

    $nearest_day = INF;
    $least_amount = INF;

    foreach ($counter as $day => $amount) {
        if (is_callable($condition) && !$condition($day)) {
            continue;
        }
        if ($amount > $least_amount) {
            continue;
        }
        if ($amount < $least_amount) {
            $least_amount = $amount;
            $nearest_day = $day;
        } elseif ($amount == $least_amount && $day < $nearest_day) {
            $nearest_day = $day;
        }
    }

    return [$nearest_day, $least_amount];
}

$days_with_titans = read_file('../last_year.json');

// Ignore the months of January and December
$condition = function ($day) {
    $year_day = $day % 365;
    return !((0 <= $year_day && $year_day < 31) || (334 <= $year_day && $year_day < 365));
};

$nearest_day = get_nearest_day($days_with_titans, $condition);
print_r($nearest_day[0]);
