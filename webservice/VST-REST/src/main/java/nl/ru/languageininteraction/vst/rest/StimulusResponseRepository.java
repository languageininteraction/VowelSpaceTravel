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

import java.util.Date;
import java.util.List;
import org.springframework.data.domain.Pageable;
import nl.ru.languageininteraction.vst.model.Difficulty;
import nl.ru.languageininteraction.vst.model.Player;
import nl.ru.languageininteraction.vst.model.Stimulus;
import nl.ru.languageininteraction.vst.model.StimulusResponse;
import nl.ru.languageininteraction.vst.model.Task;
import nl.ru.languageininteraction.vst.model.Vowel;
import org.springframework.data.domain.Page;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.data.rest.core.annotation.RestResource;

/**
 * @since Apr 8, 2015 11:29:18 AM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
@RepositoryRestResource(collectionResourceRel = "responses", path = "responses")
public interface StimulusResponseRepository extends PagingAndSortingRepository<StimulusResponse, Long> {

    @Override
    List<StimulusResponse> findAll();

    StimulusResponse findFirstByPlayerOrderByResponseDateDesc(@Param("player") Player player);
   
    List<StimulusResponse> findFirstByPlayerAndResponseDateGreaterThan(Player player, Date responseDate);

    List<StimulusResponse> findByTargetVowel(@Param("targetVowel") Vowel targetVowel);
    
    StimulusResponse  findFirstByPlayerAndTaskAndDifficultyAndTargetVowelAndStandardVowelsAndResponseDateGreaterThan(
            @Param("player") Player player,
            @Param("task") Task task,
            @Param("difficulty") Difficulty difficulty,
            @Param("targetVowel") Vowel targetVowel,
            @Param("standardVowel") Vowel standardVowel,
            @Param("responseDate") Date responseDate);
    
     List<StimulusResponse> findByPlayerAndTaskAndDifficultyAndTargetVowelAndStandardVowelsOrPlayerAndTaskAndDifficultyAndTargetVowelAndStandardVowelsOrderByResponseDateDesc(
            Player player,
            Task task,
            Difficulty difficulty,
            Vowel v1,
            Vowel s1,
            Player player1,
            Task task1,
            Difficulty difficulty1,
            Vowel v2,
            Vowel s2);
           // Pageable pageable);
     
    List<StimulusResponse> findByPlayerAndTaskAndDifficultyAndTargetVowelAndStandardVowelsOrPlayerAndTaskAndDifficultyAndTargetVowelAndStandardVowelsOrderByResponseDateDesc(
            Player player,
            Task task,
            Difficulty difficulty,
            Vowel v1,
            Vowel s1,
            Player player1,
            Task task1,
            Difficulty difficulty1,
            Vowel v2,
            Vowel s2,
            Pageable pageable);
    
    
    List<StimulusResponse> findByPlayerAndTaskAndDifficultyAndTargetVowelOrTargetVowelAndStandardVowelsOrStandardVowelsOrderByResponseDateDesc(
            @Param("player") Player player,
            @Param("task") Task task,
            @Param("difficulty") Difficulty difficulty,
            @Param("targetVowel") Vowel targetVowel1,
            @Param("targetVowel") Vowel targetVowel2,
            @Param("standardVowel") Vowel standardVowel1,
            @Param("standardVowel") Vowel standardVowel2,
            Pageable pageable);
    
    List<StimulusResponse> findTop30ByPlayerAndTaskAndDifficultyAndTargetVowelOrderByResponseDateDesc(
            @Param("player") Player player,
            @Param("task") Task task,
            @Param("difficulty") Difficulty difficulty,
            @Param("targetVowel") Vowel targetVowel);
            
    List<StimulusResponse> findByStandardVowels(@Param("standardVowel") Vowel standardVowel);

    List<StimulusResponse> findByTargetVowelAndStandardVowels(@Param("targetVowel") Vowel targetVowel, @Param("standardVowel") Vowel standardVowel);

    int countByPlayerAndTaskAndDifficultyAndTargetVowelAndStandardVowelsAndRelevanceAndPlayerResponseTrue(
            @Param("player") Player player,
            @Param("task") Task task,
            @Param("difficulty") Difficulty difficulty,
            @Param("targetVowel") Vowel targetVowel,
            @Param("standardVowel") Vowel standardVowel,
            @Param("relevance") Stimulus.Relevance relevance);

    int countByPlayerAndTaskAndDifficultyAndTargetVowelAndStandardVowelsAndRelevanceAndPlayerResponseFalse(
            @Param("player") Player player,
            @Param("task") Task task,
            @Param("difficulty") Difficulty difficulty,
            @Param("targetVowel") Vowel targetVowel,
            @Param("standardVowel") Vowel standardVowel,
            @Param("relevance") Stimulus.Relevance relevance);

    @Override
    @RestResource(exported = false)
    public void deleteAll();

    @Override
    @RestResource(exported = false)
    public void delete(Iterable<? extends StimulusResponse> itrbl);

    @Override
    @RestResource(exported = false)
    public void delete(StimulusResponse t);

    @Override
    @RestResource(exported = false)
    public void delete(Long id);

    @Override
    @RestResource(exported = false)
    public <S extends StimulusResponse> Iterable<S> save(Iterable<S> itrbl);

    @Override
    @RestResource(exported = false)
    public <S extends StimulusResponse> S save(S s);
}
