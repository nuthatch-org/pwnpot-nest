-- One row per player: CTFs entered, levels solved, and the first and last solve.
CREATE VIEW player_stats AS
  WITH entered AS (SELECT player, count(DISTINCT "ctfId") AS ctfs FROM ctf_platform__ticket_bought GROUP BY player),
       solved AS (SELECT player, count(*) AS solves, min(block_timestamp) AS first_solve, max(block_timestamp) AS last_solve
                  FROM ctf_platform__level_solved GROUP BY player)
  SELECT e.player, e.ctfs, coalesce(s.solves, 0) AS solves, s.first_solve, s.last_solve
  FROM entered e LEFT JOIN solved s ON s.player = e.player;
