/*
 * Copyright (C) 2015 Language In Interaction
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */

package nl.ru.languageininteraction.vst.rest;

import java.util.List;
import nl.ru.languageininteraction.vst.model.Player;
import nl.ru.languageininteraction.vst.model.Score;
import nl.ru.languageininteraction.vst.model.Vowel;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.data.rest.core.annotation.RestResource;

/**
 * @since Sep 16, 2015 2:35:59 PM (creation date)
 * @author Karen Dijkstra <k.dijkstra@donders.ru.nl>
 */
@RepositoryRestResource(collectionResourceRel = "score", path = "score")
public interface ScoreRepository extends PagingAndSortingRepository<Score, Long>{

    public List<Score> findAll();

    //public void deleteByPlayerAndTargetVowelAndStandardVowel(Player player, Vowel targetVowel, Vowel standardVowel);
    
    @RestResource(exported = false)
    public void deleteByPlayerAndTargetVowelAndStandardVowel(
            @Param("player") Player player,
            @Param("targetVowel") Vowel targetVowel,
            @Param("standardVowel") Vowel standardVowel);
    
    public List<Score> findByPlayer(@Param("player") Player player);
    
    @Override
    @RestResource(exported = false)
    public <S extends Score> S save(S entity);
        
}
