mob/var
	BunshinCooldown = 0
	//ataque = 10
	//defesa = 10
	//vida = 100
	chakra = 100

mob
    Bunshin
        name = "Kage Bunshin"
        density = 1
        layer = MOB_LAYER

        var
            mob/dono
            ativo = 1
            intervalo_ataque = 15
            turf/destino
            movendo = 0
            bunshin_morto = 0

mob
    Bunshin
        proc
            IniciarMovimento()
                if(!src.ativo || !src.destino || src.movendo)
                    return

                src.movendo = 1

                while(src && src.ativo && src.destino)

                    // Procura adversários próximos
                    var/mob/alvo = src.ProcurarInimigo()

                    if(alvo)
                        src.BumpAttack(alvo)
                        sleep(src.intervalo_ataque)
                        continue

                    // Verifica se chegou ao destino
                    if(get_dist(src, src.destino) <= 0)
                        break

                    // Movimenta o Bunshin
                    var/direcao = get_dir(src, src.destino)

                    if(!step(src, direcao))
                        break

                    sleep(3)

                if(src)
                    src.movendo = 0
                    src.destino = null


            ProcurarInimigo()
                for(var/mob/M in oview(1, src))

                    // Não ataca o próprio dono
                    if(M == src.dono)
                        continue

                     // Verifica se o alvo é um Kage Bunshin
                    if(istype(M, /mob/Bunshin))
                        var/mob/Bunshin/B = M

                        // Não ataca clones do mesmo dono
                        if(B.dono == src.dono)
                            continue

                    // Ignora personagens incapacitados
                    if(M.nocauteado || M.vida <= 0)
                        continue

                    return M

                return null

            BumpAttack(mob/alvo)
                if(!alvo || !src.ativo || src.atacando)
                    return

                if(get_dist(src, alvo) > 1)
                    return

                // Não ataca o próprio dono
                if(alvo == src.dono)
                    return

                if(istype(alvo, /mob/Bunshin))
                    var/mob/Bunshin/B = alvo

                    if(B.dono == src.dono)
                        return

                src.atacando = 1

                // O dano é atribuído ao dono do Bunshin.
                if(istype(alvo, /mob/Bunshin))
                    var/mob/Bunshin/B = alvo
                    B.ReceberDanoBunshin(src.ataque)
                else
                    alvo.ReceberDano(src.ataque, src.dono, 0, "fisico")

                if(src.dono)
                    src.dono << "Seu Kage Bunshin atacou [alvo]!"

                spawn(src.intervalo_ataque)
                    if(src)
                        src.atacando = 0

            ReceberDanoBunshin(quantidade)
                if(!src || !src.ativo || src.vida <= 0)
                    return

                src.vida -= quantidade

                if(src.vida <= 0)
                    src.vida = 0
                    src.MorrerBunshin()
                    return

                if(src.dono)
                    src.dono << "Vida do Kage Bunshin: [src.vida]/[src.vida]"

            MorrerBunshin()
                if(!src || src.bunshin_morto)
                    return

                src.bunshin_morto = 1
                src.ativo = 0
                src.vida = 0

                new /obj/EfeitoFumaca(src.loc)
                del(src)


mob/proc/CriarBunshin(limite = 3)

    var/criados = 0

    // Procura espaços livres em um raio de 5 tiles
    for(var/turf/P in orange(5, src))

        if(!P || P.density || P == src.loc)
            continue

        // Verifica se já existe algum personagem no tile
        var/ocupado = 0

        for(var/mob/M in P)
            ocupado = 1
            break
        if(ocupado)
            continue

        // Cria a fumaça
        new /obj/EfeitoFumaca(P)

        // Cria o Bunshin
        var/mob/Bunshin/B = new /mob/Bunshin(P)

        B.appearance = src.appearance
        B.name = src.name
        B.dir = src.dir
        B.dono = src

        // Calcula a força individual do Bunshin
        B.ataque = 5 + round(src.ataque * 0.3)
        if(B.ataque < 10)
            B.ataque = 10
        //src << "Força do criador: [src.ataque]"
        //src << "Força individual do Bunshin: [B.ataque]"
        B.vida = 10
        B.vida = 10
        B.density = 1
        B.defesa = round(src.defesa * 0.1)
        B.layer = MOB_LAYER

        // Desaparece após 30 segundos
        spawn(600)
            if(B)
                new /obj/EfeitoFumaca(B.loc)
                del(B)

        criados++

        if(criados >= limite)
            break

    if(criados > 0)
        src << "Você criou [criados] clones das sombras!"

    else
        src << "Não há espaço para criar seus clones."
    return criados

mob/bunshin
    verb
        kBunshinNoJutsu()

            set category = "Ninjutsu"
            set name = "Kage Bunshin no Jutsu"

            var/mob/P = usr

            if(P.chakra < 50)
                P << "Sem chakra suficiente!"
                return

            if(P.BunshinCooldown > 0)
                P << "Kage Bunshin no Jutsu ainda está em tempo de recarga de [P.BunshinCooldown] segundos!"
                return

            var/seals_ok = P.Handseals()

            if(!seals_ok)
                return

            // Consumo de Chakra
            P.chakra -= 50

            P.handseals = 0

            // Cooldown
            P.BunshinCooldown = 10

            spawn()
                while(P && P.BunshinCooldown > 0)

                    sleep(10)

                    if(!P)
                        break

                    P.BunshinCooldown--

                    //if(P.BunshinCooldown > 0)
                        //P << "Kage Bunshin disponível em [P.BunshinCooldown] segundos."

            // Execução
            view() << "<b>[P] diz: Kage Bunshin no Jutsu!</b>"

            P.CriarBunshin(3)

mob/bunshin
    verb
        DesfazerBunshin()
            set name = "Desfazer Bunshins"
            set category = "Ninjutsu"

            var/removidos = 0

            for(var/mob/Bunshin/B in world)
                if(B.dono == usr)
                    new /obj/EfeitoFumaca(B.loc)
                    del(B)
                    removidos++

            if(removidos > 0)
                usr << "Você desfez seus [removidos] clones das sombras!"
                view() << "[usr] desfez os Kage Bunshins!"
            else
                usr << "Você não possui Kage Bunshins ativos."

obj
    EfeitoFumaca
        name = ""
        icon = 'player.dmi'
        icon_state = "smoke2"
        density = 0
        layer = MOB_LAYER + 1

        New()
            ..()
            spawn(10)
                if(src)
                    del(src)


client
    Click(atom/target, location, control, params)

        var/list/P = params2list(params)

        if(P["button"] != "left")
            return ..()

        if(!src.mob)
            return

        var/turf/T

        if(isturf(target))
            T = target
        else if(target)
            var/atom/A = target
            while(A && !isturf(A))
                A = A.loc

            if(isturf(A))
                T = A

        if(!T)
            return

        for(var/mob/Bunshin/B in world)
            if(B.dono == src.mob)
                B.destino = T
                B.IniciarMovimento()

        return