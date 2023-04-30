create or replace function store_player_rating_to_history()
  RETURNS trigger as
$BODY$
begin
  insert into chess.rating_history (fide, elo, title, dt)
  values (old.fide, old.elo, old.title, current_date);
  return new;
end;
$BODY$
  LANGUAGE plpgsql;

CREATE TRIGGER update_player_rating_tg
    before update on chess.player
    for each row 
    when ((old.elo <> new.elo OR old.title <> new.title) AND old.fide = new.fide)
    EXECUTE PROCEDURE store_player_rating_to_history();
