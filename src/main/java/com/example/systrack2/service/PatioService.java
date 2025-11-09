package com.example.systrack2.service;

import com.example.systrack2.domain.Patio;
import com.example.systrack2.DTO.Request.PatioRequestDTO;
import com.example.systrack2.DTO.Response.PatioResponseDTO;
import com.example.systrack2.repository.PatioRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PatioService {

    private final PatioRepository patioRepository;

    public PatioResponseDTO criar(PatioRequestDTO dto) {
        Patio patio = new Patio();
        patio.setNome(dto.getNome());
        patio.setEndereco(dto.getEndereco());
        patio = patioRepository.save(patio);

        return toResponse(patio);
    }

    public List<PatioResponseDTO> listar() {
        return patioRepository.findAll().stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    public PatioResponseDTO buscarPorId(Long id) {
        Patio patio = patioRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Pátio não encontrado"));
        return toResponse(patio);
    }

    public PatioResponseDTO atualizar(Long id, PatioRequestDTO dto) {
        Patio patio = patioRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Pátio não encontrado"));

        patio.setNome(dto.getNome());
        patio.setEndereco(dto.getEndereco());
        patio = patioRepository.save(patio);

        return toResponse(patio);
    }

    public void excluir(Long id) {
        if (!patioRepository.existsById(id)) {
            throw new EntityNotFoundException("Pátio não encontrado");
        }
        patioRepository.deleteById(id);
    }

    private PatioResponseDTO toResponse(Patio patio) {
        PatioResponseDTO dto = new PatioResponseDTO();
        dto.setId(patio.getId());
        dto.setNome(patio.getNome());
        dto.setEndereco(patio.getEndereco());
        dto.setQtdMotos(patio.getMotos() != null ? patio.getMotos().size() : 0);
        return dto;
    }
}
