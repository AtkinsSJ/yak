<?php

$config = parse_ini_file('config.ini');
$conn = new PDO("mysql:host={$config['host']};dbname={$config['dbname']}", $config['username'], $config['password']);

if (isset($_GET['setscore'])) {
	echo 'Submitting score';
	$score = intval($_GET['score']);
	$name = $_GET['name'];

	$stmt = $conn->prepare(
		'INSERT INTO yak_scores (score, name)
		VALUES (:score, :name)'
	);
	$success = $stmt->execute(array(
		'score' => $score,
		'name' => $name
	));

	if (!$success) {
		print_r($stmt->errorInfo());
	}
} elseif (isset($_GET['getscores'])) {
	$stmt = $conn->prepare(
		'SELECT * FROM yak_scores
		ORDER BY score DESC
		LIMIT 10');
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_ASSOC);

	echo '<?xml version="1.0"?><scores>';
	foreach ($result as $row) {
		echo "<score name='{$row['name']}'>{$row['score']}</score>";
	}
	echo '</scores>';
}

?>