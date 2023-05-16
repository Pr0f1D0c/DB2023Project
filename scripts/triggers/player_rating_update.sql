create or replace function insert_amateur_game()
    returns trigger as
$BODY$
begin
    with prev_white as (
        select rating from chess.amateur where id = NEW.white
    )
    update chess.amateur
    set rating =
        case NEW.result
            when '1-0' then (select * from prev_white) + TG_ARGV[0]::integer
            when '0-1' then (select * from prev_white) - TG_ARGV[0]::integer
            when '1/2-1/2' then (select * from prev_white)
        end
    where id = NEW.white;

    with prev_black as (
        select rating from chess.amateur where id = NEW.black
    )
    update chess.amateur
    set rating =
        case NEW.result
            when '1-0' then (select * from prev_black) + TG_ARGV[0]::integer
            when '0-1' then (select * from prev_black) - TG_ARGV[0]::integer
            when '1/2-1/2' then (select * from prev_black)
        end
    where id = NEW.black;

    return NEW;
end;
$BODY$
language plpgsql;

create or replace trigger insert_amateur_game_trigger
  after insert on chess.amateur_game
  for each row
  execute function insert_amateur_game(5);
