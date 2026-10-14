-- Lucky Jim's Ranch : brouillon de migration, à valider sur le schéma existant.
-- Ne jamais exécuter sur le projet LSPD/EMS.
-- Nécessite ranch_memberships(user_id,active,role),
-- ranch_employees(user_id,name,active), ranch_articles(id,name,unit_price,active,data),
-- ranch_harvests(...), ranch_deliveries(...), ranch_settings(key,value).
-- IMPORTANT : compléter et auditer toutes les politiques RLS avant mise en production.

create or replace function public.ranch_record_harvest(p_article_id bigint,p_quantity numeric)
returns bigint language plpgsql security definer set search_path=public as $$
declare a record; e record; v_bonus numeric; v_id bigint;
begin
 if auth.uid() is null or not exists(select 1 from public.ranch_memberships where user_id=auth.uid() and active=true)
 then raise exception 'Accès refusé'; end if;
 if p_quantity is null or p_quantity<=0 or p_quantity>1000000 then raise exception 'Quantité invalide'; end if;
 select * into a from public.ranch_articles where id=p_article_id and active=true for share;
 if not found then raise exception 'Article indisponible'; end if;
 select * into e from public.ranch_employees where user_id=auth.uid() and active=true limit 1;
 if not found then raise exception 'Employé introuvable'; end if;
 v_bonus=round(p_quantity*coalesce(a.unit_price,0)*coalesce(nullif(a.data->>'primePct','')::numeric,0)/100,2);
 insert into public.ranch_harvests(harvest_date,employee,product,quantity,rate,bonus_amount,data)
 values(current_date,e.name,a.name,p_quantity,a.unit_price,v_bonus,jsonb_build_object('article_id',a.id,'prime_pct',coalesce(a.data->>'primePct','0'),'user_id',auth.uid()))
 returning id into v_id;
 return v_id;
end; $$;

create or replace function public.ranch_record_delivery()
returns bigint language plpgsql security definer set search_path=public as $$
declare e record; v_bonus numeric; v_id bigint;
begin
 if auth.uid() is null or not exists(select 1 from public.ranch_memberships where user_id=auth.uid() and active=true)
 then raise exception 'Accès refusé'; end if;
 select * into e from public.ranch_employees where user_id=auth.uid() and active=true limit 1;
 if not found then raise exception 'Employé introuvable'; end if;
 select (value #>> '{}')::numeric into v_bonus from public.ranch_settings where key='delivery_bonus';
 if v_bonus is null or v_bonus<0 then raise exception 'Prime de livraison non configurée'; end if;
 insert into public.ranch_deliveries(delivery_date,farmer_driver,bonus_amount,validated_by,data)
 values(current_date,e.name,v_bonus,e.name,jsonb_build_object('user_id',auth.uid()))
 returning id into v_id;
 return v_id;
end; $$;

revoke all on function public.ranch_record_harvest(bigint,numeric) from public,anon;
revoke all on function public.ranch_record_delivery() from public,anon;
grant execute on function public.ranch_record_harvest(bigint,numeric) to authenticated;
grant execute on function public.ranch_record_delivery() to authenticated;
